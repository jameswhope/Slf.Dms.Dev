IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CollectDisbursements')
	BEGIN
		DROP  Procedure  stp_CollectDisbursements
	END

GO

CREATE Procedure [dbo].[stp_CollectDisbursements]
as
/*
	jhernandez		04.09.09	Pickup voided disbursements.
	jhernandez		06.18.09	Filter by client conversion date (where avail)
*/

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
		abs(r.amount) [amount],
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
insert tblNachaRegister2
	([name],amount,ispersonal,companyid,ShadowStoreId,ClientID,TrustID,RegisterId,Flow)
select 
	@trustdisplay,amount,0,companyid,ShadowStoreId,d.ClientID,@trustid,RegisterId,Flow
from 
	#disbur d
join 
	#conver c on c.clientid = d.clientid
	and c.converdate < d.transactiondate


drop table #disbur
drop table #conver