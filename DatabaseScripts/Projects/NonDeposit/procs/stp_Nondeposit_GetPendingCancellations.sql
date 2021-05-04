IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Nondeposit_getPendingCancellations')
	BEGIN
		DROP  Procedure  stp_Nondeposit_getPendingCancellations
	END

GO

CREATE Procedure stp_Nondeposit_getPendingCancellations
@LawFirmId int = null
AS
Select pc.CancellationId,
pc.ClientId, 
c.AccountNumber,
ClientName = isnull(p.FirstName, '') + ' ' + isnull(p.LastName, ''), 
co.ShortCoName, 
pc.Created
from tblnondepositpendingcancellation pc
inner join tblclient c on pc.clientid = c.clientid
inner join tblperson p on p.personid = c.primarypersonid
inner join tblcompany co on co.companyid = c.companyid
Where c.currentclientstatusid not in (15, 17, 18, 22)
and pc.deleted is null
and  (@LawFirmId is null or c.companyid = @LawFirmId)

GO

 

