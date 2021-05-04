IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetEmailClientsFollowup')
		DROP  Procedure  stp_GetEmailClientsFollowup
GO

create procedure stp_GetEmailClientsFollowup
as
begin
/*
	Daily routine used to send auto-generated emails to clients 1 week after their Welcome email was sent
*/

	select c.clientid, c.agencyid, p.firstname + ' ' + p.lastname [clientname], p.emailaddress, 
		cp.name [company], ca.address1 + ', ' + ca.city + ', ' + ca.state + ' ' + ca.zipcode [companyaddress],
		p1.phonenumber [clientservicesphone], f.phonenumber [clientservicesfax], cr.phonenumber [creditorservicesphone]
	from tblclientemails e
	join tblclient c on c.clientid = e.clientid 
	join tblcompany cp on cp.companyid = c.companyid
	join tblcompanyaddresses ca on ca.companyid = cp.companyid and ca.addresstypeid = 3 -- Client
	join tblcompanyphones p1 on p1.companyid = cp.companyid and p1.phonetype = 46 -- CustomerServicePhone
	join tblcompanyphones f on f.companyid = cp.companyid and f.phonetype = 47 -- CustomerServiceFax
	join tblcompanyphones cr on cr.companyid = cp.companyid and cr.phonetype = 50 -- CreditorServicesPhone
	join tblperson p on p.personid = c.primarypersonid
	where 1=1
	and e.type = 'Welcome'
	and c.currentclientstatusid = 14 -- must still be active active
	and datediff(d,e.datesent,getdate()) = 7 -- Send 1 week after the Welcome email
	and c.clientid not in (select distinct clientid from tblclientemails where [type] = 'Follow-up')
	and p.emailaddress is not null 

end
go 