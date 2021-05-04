IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetEmailClientsWelcome')
		DROP  Procedure  stp_GetEmailClientsWelcome
GO

create procedure stp_GetEmailClientsWelcome
as
begin
/*
	Daily routine used to send auto-generated Welcome emails to clients
*/

	select c.clientid, p.firstname + ' ' + p.lastname [clientname], p.emailaddress, 
		cp.name [company], ca.address1 + ', ' + ca.city + ', ' + ca.state + ' ' + ca.zipcode [companyaddress],
		p1.phonenumber [clientservicesphone], f.phonenumber [clientservicesfax], cr.phonenumber [creditorservicesphone],
		cp.website
	from tblclient c 
	join tblcompany cp on cp.companyid = c.companyid
	join tblcompanyaddresses ca on ca.companyid = cp.companyid and ca.addresstypeid = 3 -- Client
	join tblcompanyphones p1 on p1.companyid = cp.companyid and p1.phonetype = 46 -- CustomerServicePhone
	join tblcompanyphones f on f.companyid = cp.companyid and f.phonetype = 47 -- CustomerServiceFax
	join tblcompanyphones cr on cr.companyid = cp.companyid and cr.phonetype = 50 -- CreditorServicesPhone
	join tblperson p on p.personid = c.primarypersonid
	join vw_ClientCurrentStatusCreated v on v.clientid = c.clientid
	where 1=1
	and c.currentclientstatusid = 14 -- active
	and v.minstatuscreated > '3/31/2010' -- date we started these emails
	and datediff(d,v.statuscreated,getdate()) > 0
	and c.clientid not in (select distinct clientid from tblclientemails where [type] = 'Welcome')
	and p.emailaddress is not null 
	
end
go