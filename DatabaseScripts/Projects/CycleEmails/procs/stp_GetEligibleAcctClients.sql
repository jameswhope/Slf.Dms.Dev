IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetEligibleAcctClients')
		DROP  Procedure  stp_GetEligibleAcctClients
GO

create procedure stp_GetEligibleAcctClients
as
begin
/*
	Daily routine used to send auto-generated emails to clients notifying them about accounts on their credit report
	that they didn't enroll with us. A check will be performed to see if these clients have any
	eligible accounts first before sending out the email.
*/

select c.clientid, lc.leadapplicantid, p.emailaddress, cp.name [company]
from tblclient c 
join tblcompany cp on cp.companyid = c.companyid
join tblperson p on p.personid = c.primarypersonid
join vw_ClientCurrentStatusCreated v on v.clientid = c.clientid
join vw_leadapplicant_client lc on lc.clientid = c.clientid
where 1=1
and c.currentclientstatusid = 14 -- active
and convert(varchar(10),v.statuscreated,101) = convert(varchar(10),dateadd(d,-1,getdate()),101) -- get active clients from yesturday
and c.clientid not in (select distinct clientid from tblclientemails where [type] = 'Eligible')
and p.emailaddress is not null  


end
go