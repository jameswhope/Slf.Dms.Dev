
alter procedure stp_ClientsByState
(
	@CompanyID int,
	@StateID int,
	@GroupID int
)
as
begin

	select c.clientid, c.accountnumber, p.lastname + ', ' + p.firstname [name], p.street, p.city, 
		isnull(s.name,'') [state], cs.name [status]
	from tblclient c
	join tblperson p on p.personid = c.primarypersonid
		and isnull(p.stateid,0) = @StateId
	join tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
	join tblclientstatusxref x on x.clientstatusgroupid = @GroupID and x.clientstatusid = cs.clientstatusid
	left join tblstate s on s.stateid = p.stateid
	where c.companyid = @CompanyID
	order by [name]

end
go