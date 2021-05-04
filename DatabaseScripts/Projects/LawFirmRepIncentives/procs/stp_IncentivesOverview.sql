
alter procedure stp_IncentivesOverview
as
begin

	select l.repid, u.firstname + ' ' + u.lastname [rep], max(n.created) [lastincentive], max(c.created) [lastclient], isnull(r.userid,-1) [supid]
	from tblclient c
	join tblimportedclient i on i.importid = c.serviceimportid
	join tblleadapplicant l on l.leadapplicantid = i.externalclientid
	join tbluser u on u.userid = l.repid and u.locked = 0
	left join tblincentives n on n.repid = l.repid
	left join tblsupreps r on r.userid = n.repid
	group by l.repid, u.firstname, u.lastname, r.userid
	having max(c.created) > dateadd(day,-45,getdate())

end 
go 