IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNonRepClients')
		DROP  Procedure  stp_GetNonRepClients
GO

create procedure stp_GetNonRepClients
as
begin
/*
	Daily routine used to send auto-generated emails to leads who were sent to Compliance, returned to CID, then
	set to Declined Representation (No Sale) by a CID rep.
*/

select distinct v.leadapplicantid, lc.clientid, l.leadname, l.email, c.name [company], c.contact1, p.phonenumber
from vw_enrollment_CurrentStatusCreated v
join tblleadstatusroadmap r on r.leadapplicantid = v.leadapplicantid
	and r.leadstatusid = 18 -- Returned to CID
join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
	and l.email like '%@%.%'
join tblcompany c on c.companyid = l.companyid
join tblcompanyphones p on p.companyid = c.companyid
	and p.phonetype = 46 -- CustomerServicePhone
join vw_leadapplicant_client lc on lc.leadapplicantid = l.leadapplicantid
	and lc.clientid not in (select distinct clientid from tblclientemails where [type] = 'Non-rep')
where v.currentstatusid = 12 -- No Sale
	and v.statuscreated > cast(convert(varchar(10),dateadd(d,-1,getdate()),101) as datetime)
 
 
end
go