IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetChecksiteClientsToBalance')
	BEGIN
		DROP  Procedure  stp_GetChecksiteClientsToBalance
	END

GO

CREATE Procedure stp_GetChecksiteClientsToBalance
@age int = 45
AS
Begin

-- Get clients with pending disbursements to Collect
declare @trustid int, @trustdisplay varchar (50)

-- Lexxiom Creditor Clearing Account
select @trustid = trustid, @trustdisplay = [name]
from tbltrust 
where trustid = 23


-- get un-batched disbursements for checksite clients
select
	amount,companyid,ShadowStoreId,ClientID,RegisterId,Flow,TransactionDate
into
	#disbur
from (
	-- shadow store -> disbursement account
	select 
		abs(r.amount) [amount],
		c.companyid,
		c.accountnumber [ShadowStoreId],
		r.ClientId,
		r.registerid,
		'debit' [Flow],
		r.TransactionDate
	from 
		tblregister as r 
	join tblentrytype as e on r.entrytypeid = e.entrytypeid
		and e.entrytypeid in (28, 21, 18, 48) -- Client Withdrawal, Closing Withdrawal, Settlement, Refund
	join tblclient as c on c.clientid = r.clientid 
		and c.trustid = 22
	where r.amount < 0 and r.isfullypaid = 0 and r.void is null and r.bounce is null

	union all

	-- disbursement account -> shadow store
	select 
		abs(r.amount) * -1 [amount],
		c.companyid,
		c.accountnumber [ShadowStoreId],
		r.ClientId,
		r.registerid,
		'credit' [Flow],
		r.TransactionDate
	from 
		tblregister as r 
	join tblentrytype as e on r.entrytypeid = e.entrytypeid
		and e.entrytypeid in (28, 21, 18, 48) -- Client Withdrawal, Closing Withdrawal, Settlement, Refund
	join tblclient as c on c.clientid = r.clientid 
		and c.trustid = 22
	join tblnacharegister2 as nr on nr.registerid = r.registerid
		and nr.clientid = c.clientid
	where r.amount < 0 and r.isfullypaid = 0 and r.void is not null and r.bounce is null

) sub
where not exists (select 1 from tblNachaRegister2 nr2 where nr2.RegisterID = sub.RegisterID and nr2.flow = sub.flow)

-- get client conversion dates (where avail) 
select d.clientid, isnull(max(a.dc),'1/1/1900') [converdate]
into #conver
from #disbur d
left join tblaudit a on a.pk = d.clientid
	and a.auditcolumnid = 27
group by d.clientid

-- and only batch disbursements that occurred after their conversion date
select 
	d.ClientID As [ClientId], Sum(amount) as [Amount]
into #disbursum
from 
	#disbur d
join 
	#conver c on c.clientid = d.clientid
	and c.converdate < d.transactiondate
Group by d.ClientId


declare @olddate datetime 
select @olddate = cast('2000-01-01' as datetime)

--Get all clients that:
-- Did not balance last time
Select Distinct z.ClientId
into #c 
From 
(
Select b.Clientid as [ClientId] From tblBalanceLog b
Where b.balanced <> 1 and b.lastcheck is not null
Union
-- Have a new deposit or bounced or voided transaction after the last balance check
Select b.Clientid From tblBalanceLog b
inner join tblregister r on r.ClientId = b.ClientId
Where r.entrytypeid = 3
and ((r.created >= isnull(b.lastCheck, @olddate))
or (r.bounce is not null and r.bounce >= isnull(b.lastCheck, @olddate))
or (r.void is not null and r.void >= isnull(b.lastCheck, @olddate)))
Union 
-- Have a transaction transaction after the last balance check
Select b.clientid From tblBalanceLog b
inner join tblnacharegister2 n on n.clientid = b.clientid
where created >= isnull(b.lastCheck, @olddate)
Union
-- Active clients that havent been checked in a while
Select b.clientid from tblBalanceLog b
inner join tblclient c on c.clientid =  b.clientid and c.currentclientstatusid not in (15, 17, 18)
Where b.lastcheck is not null and datediff(d, b.lastcheck, getdate()) >= @age
Union
--Clients with pending disbursements
Select d.clientid from #disbursum d
) z

Select 
	c.ClientId,
	c.SDABalance AS [SDABalance],
	(select 
	coalesce(sum(nr.amount), 0)
	from tblNacharegister2 nr
	left join tblNachaFile nf on nf.nachafileid = nr.nachafileid 
	where (nf.datesent is null and (nr.nachafileid > 0 or nr.nachafileid = -1))
	and nr.flow = 'debit'
	and nr.shadowstoreid = c.AccountNumber) +
	(select 
	coalesce(sum(nr.amount), 0)* -1
	from tblNacharegister2 nr
	left join tblNachaFile nf on nf.nachafileid = nr.nachafileid 
	where (nf.datesent is null and (nr.nachafileid > 0 or nr.nachafileid = -1))
	and nr.flow = 'credit'
	and nr.shadowstoreid = c.AccountNumber) as [PendingAmount],
	(select
	coalesce(sum(amount), 0)
	from tblRegister r
	Where r.bounce is null and r.void is null and r.[clear] is null
	and r.checknumber is not null
	and r.clientid = c.clientid
	and r.entrytypeid = 3
	and not exists(Select depositid from tblc21batchtransaction where depositid = r.registerid)) as [PendingC21],
	Case When CurrentClientStatusId IN (15, 17, 18) Then 0 Else 1 End As [Active],
	AccountNumber,
	p.FirstName,
	p.LastName,
	(select coalesce(sum(r.amount), 0)* -1
	 from tblregister r
	 where r.entrytypeid = 3
	 and datediff(d, r.created, getdate()) < 3
	 and (r.hold is not null and r.hold > getdate())
	 and r.clear is null
	 and r.void is null
	 and r.bounce is null
	 and r.importid is null
	 and r.checknumber is not null
	 and r.clientid = c.clientid
	 and r.registerid not in (select b.depositid from tblc21batchtransaction b where b.depositid is not null)) as [C21ToSend],
	 isnull(d.Amount, 0) as [Disbursement]
FROM tblClient c
Inner Join tblPerson p on p.ClientId = c.ClientId
Left Join #disbursum d on c.ClientId = d.ClientId
Where c.TrustId = 22
And p.relationShip = 'prime'
And c.AccountNumber is not null -- If manual entry and data entry has not been resolved, clients will not have an account number yet
--Exclude those not send to Checksite
--And c.ClientId in (Select distinct Clientid From tblNachaRegister2 Where isNull(NachaFileId,-1) <> -1)
And c.clientId in (Select clientId from #c)
Order by p.LastName, p.FirstName

drop table #c
drop table #disbur
drop table #conver
drop table #disbursum

End

GO



