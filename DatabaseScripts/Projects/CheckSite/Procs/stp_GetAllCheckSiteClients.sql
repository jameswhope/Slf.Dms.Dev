IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAllCheckSiteClients')
	BEGIN
		DROP  Procedure  stp_GetAllCheckSiteClients
	END

GO

CREATE Procedure stp_GetAllCheckSiteClients
AS
Select 
	c.ClientId,
	round(c.SDABalance,2) AS [SDABalance],
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
	and nr.shadowstoreid = c.AccountNumber) [PendingAmount],
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
	 and r.registerid not in (select b.depositid from tblc21batchtransaction b where b.depositid is not null)) as [C21ToSend]
FROM tblClient c
Inner Join tblPerson p on p.ClientId = c.ClientId
Where TrustId = 22
And p.relationShip = 'prime'
And c.AccountNumber is not null -- If manual entry and data entry has not been resolved, clients will not have an account number yet
--Exclude those not send to Checksite
--And c.ClientId in (Select distinct Clientid From tblNachaRegister2 Where isNull(NachaFileId,-1) <> -1)
Order by p.LastName, p.FirstName



GO

