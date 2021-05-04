IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Nondeposit_GetPendingExceptions')
	BEGIN
		DROP  Procedure  stp_Nondeposit_GetPendingExceptions
	END

GO

CREATE Procedure stp_Nondeposit_GetPendingExceptions
@CompanyId int = null
AS
select 
ExceptionId = e.NonDepositExceptionId,
pl.clientid, 
e.planid,
ClientName = isnull(p.FirstName, '') + ' ' + isnull(p.LastName, ''), 
co.ShortCoName,
pl.ScheduledDate, 
pl.ExpectedDepositAmount,
c.AccountNumber
from tblnondepositexception e
inner join tblplanneddeposit pl on pl.planid = e.planid
inner join tblclient c on c.clientid = pl.clientid
inner join tblperson p on p.personid = c.primarypersonid
inner join tblcompany co on co.companyid = c.companyid
where e.fixed = 0
and c.currentclientstatusid not in (15, 17, 18, 22)
and (@CompanyId is null or c.companyid = @CompanyId)
and e.nondepositexceptionid > 585

GO

 

