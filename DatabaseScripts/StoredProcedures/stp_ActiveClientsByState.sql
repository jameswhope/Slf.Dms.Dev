
drop procedure stp_ActiveClientsByState
go

create procedure stp_ActiveClientsByState
(
	@UserID int,
	@GroupID int
)
as
begin

	select cp.companyid, cp.name [company], s.stateid, s.name [state]
	into #states
	from tblstate s, tblcompany cp

	insert #states select distinct companyid, company, 0, 'Unknown' from #states
	insert #states select distinct companyid, company, -1, '' from #states

	select companyid, stateid, [count]
	into #states1
	from (
		select c.companyid, -1 [stateid], count(*) [count]
		from tblclient c
		join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = @userid
		join tblperson p on p.personid = c.primarypersonid
		join tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
		join tblclientstatusxref x on x.clientstatusgroupid = @GroupID and x.clientstatusid = cs.clientstatusid
		group by c.companyid

		union all

		select c.companyid, isnull(p.stateid,0), count(*)
		from tblclient c
		join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = @userid
		join tblperson p on p.personid = c.primarypersonid
		join tblclientstatus cs on cs.clientstatusid = c.currentclientstatusid
		join tblclientstatusxref x on x.clientstatusgroupid = @GroupID and x.clientstatusid = cs.clientstatusid
		group by c.companyid, p.stateid
	) d

	select row_number() over(order by s.company, s.state) [rownum], 
		s.companyid, s.company, s.stateid, s.state, isnull(s1.[count],0) [count]
	from #states s
	left join #states1 s1 on s1.companyid = s.companyid
	and s1.stateid = s.stateid

	drop table #states
	drop table #states1

end
go