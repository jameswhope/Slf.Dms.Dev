IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_LeadApplicant_Client')
	BEGIN
		DROP vw_LeadApplicant_Client
	END
GO

CREATE View vw_LeadApplicant_Client AS
select a.leadapplicantid, c.clientid
from tblclient c 
inner join tblimportedclient i on i.importid = c.serviceimportid
inner join tblleadapplicant a on a.leadapplicantid = i.externalclientid and i.sourceid =1
 

GO

