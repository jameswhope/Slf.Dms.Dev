
alter procedure stp_CreditorValidationDetail
(
	@UserID int
)
as
begin

	-- active validated 
	select c.creditorid, g.name, c.street, c.street2, c.city, s.name [state], c.zipcode, h.created, h.createdby, 1 [active]
	into #validated
	from tblcreditorhistory h
	join tblcreditor c on c.creditorid = h.creditorid
	join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid
	left join tblstate s on s.stateid = c.stateid
	where h.createdby = @UserID
	and h.validated = 1

	-- inactive validated (no longer in tblCreditor)
	insert #validated
	select h.creditorid, h.name, h.street, h.street2, h.city, s.name [state], h.zipcode, h.created, h.createdby, 0 [active]
	from tblcreditorhistory h
	left join tblstate s on s.stateid = h.stateid
	where h.createdby = @UserID
	and h.validated = 1
	and h.creditorid not in (select creditorid from #validated)

	select * from #validated order by creditorid desc
	drop table #validated


	-- active approved
	select c.creditorid, g.name, c.street, c.street2, c.city, s.name [state], c.zipcode, h.created, h.createdby, 1 [active]
	into #approved
	from tblcreditorhistory h
	join tblcreditor c on c.creditorid = h.creditorid
	join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid
	left join tblstate s on s.stateid = c.stateid
	where h.createdby = @UserID
	and h.approved = 1

	-- inactive approved (no longer in tblCreditor)
	insert #approved
	select h.creditorid, h.name, h.street, h.street2, h.city, s.name [state], h.zipcode, h.created, h.createdby, 0 [active]
	from tblcreditorhistory h
	left join tblstate s on s.stateid = h.stateid
	where h.createdby = @UserID
	and h.approved = 1
	and h.creditorid not in (select creditorid from #approved)

	select * from #approved order by creditorid desc
	drop table #approved


	-- dups
	select h.creditorid, h.name, h.street, h.street2, h.city, s.name [state], h.zipcode, h.created, h.createdby, 0 [active]
	into #dups
	from tblcreditorhistory h
	left join tblstate s on s.stateid = h.stateid
	where h.createdby = @UserID
	and h.duplicate = 1

	-- replaced with
	insert #dups
	select h.creditorid, g.name, c.street, c.street2, c.city, s.name [state], c.zipcode, c.created, c.createdby, 1 [active]
	from tblcreditorhistory h
	join tblcreditor c on c.creditorid = h.newcreditorid
	join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid
	left join tblstate s on s.stateid = c.stateid
	where h.createdby = @UserID
	and h.duplicate = 1

	select * from #dups order by creditorid desc, active
	drop table #dups



	select u.firstname+' '+u.lastname [name], g.name [group] 
	from tbluser u 
	join tblusergroup g on g.usergroupid = u.usergroupid 
	where u.userid = @UserID
	

end
go 