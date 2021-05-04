
alter procedure stp_CreditorHistoryStats
as
begin

	select h.createdby, u.firstname + ' ' + u.lastname [name], ug.name [dept],
		sum(case when h.validated = 1 then 1 else 0 end) [validated],
		sum(case when h.approved = 1 then 1 else 0 end) [approved],
		sum(case when h.duplicate = 1 then 1 else 0 end) [duplicates],
		sum(case when h.validated = 0 and h.approved = 0 and h.duplicate = 0 and c.creditorid is not null then 1 else 0 end) [pending],
		count(h.creditorhistoryid) [total],
		max(h.created) [lastInsertion]
	from tblcreditorhistory h
	left join tblcreditor c on c.creditorid = h.creditorid
	left join tbluser u on u.userid = h.createdby
	left join tblusergroup ug on ug.usergroupid = u.usergroupid
	group by h.createdby, u.firstname, u.lastname, ug.name
	order by [total] desc, u.firstname, u.lastname

end
go 