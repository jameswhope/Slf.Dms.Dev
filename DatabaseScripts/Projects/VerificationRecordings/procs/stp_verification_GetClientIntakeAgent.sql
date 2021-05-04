IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_verificationCall_GetClientIntakeAgent')
	BEGIN
		DROP  Procedure  stp_verificationCall_GetClientIntakeAgent
	END

GO

CREATE Procedure stp_verificationCall_GetClientIntakeAgent
@CLientId int
AS
select a.repid, u.username, isnull(u.FirstName,'') + ' ' + isnull(u.LastName,'') as [FullName]
from tblclient c 
inner join tblimportedclient i on i.importid = c.serviceimportid
inner join tblleadapplicant a on a.leadapplicantid = i.externalclientid and i.sourceid =1
inner join tbluser u on u.userid = a.repid
where c.clientid = @ClientId


GO

 
