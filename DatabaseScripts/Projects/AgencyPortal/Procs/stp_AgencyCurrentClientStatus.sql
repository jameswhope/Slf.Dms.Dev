
if exists (select * from sysobjects where name = 'stp_AgencyCurrentClientStatus')
	drop procedure stp_AgencyCurrentClientStatus
go

create procedure stp_AgencyCurrentClientStatus
(
	@UserID int,
	@CompanyID int = -1
)
as
begin

	select cs.name, count(c.clientid) [count]
	from tblclient c
	join tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
	join tbluseragencyaccess a on a.agencyid = c.agencyid and a.userid = @UserID
	join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = a.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	join tbluserclientaccess uc on uc.userid = uca.userid and c.created between uc.clientcreatedfrom and uc.clientcreatedto
	group by cs.name
	order by [count] desc

end
go