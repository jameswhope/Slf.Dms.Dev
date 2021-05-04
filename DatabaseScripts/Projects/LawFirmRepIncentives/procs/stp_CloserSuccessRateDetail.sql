IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CloserSuccessRateDetail')
	DROP  Procedure  stp_CloserSuccessRateDetail
GO

create procedure stp_CloserSuccessRateDetail
(
	@repid int,
	@month int,
	@year int
	
)
as
begin

declare @usergroupid int, @sql varchar(100)

select @usergroupid = usergroupid
from tbluser
where userid = @repid

if @usergroupid = 25
	set @sql = ' and u.usergroupid in (25) -- CID Closers'
else
	set @sql = ' and u.usergroupid in (1,24,26,28,29) -- CID Fronters'


exec('
-- get closers for the month
select min(a.leadauditid) [leadauditid]
into #leadauditids
from tblleadapplicant l
join tblLeadAudit a on a.leadapplicantid = l.leadapplicantid
	and a.leadfield = ''RepID''
join tblUser u on u.userid = a.newvalue'
	+ @sql + '
where month(l.created) = ' + @month + '
	and year(l.created) = ' + @year + '
group by l.leadapplicantid

-- output
select 
	l.leadapplicantid, 
	l.leadname, 
	s.description [status],
	l.created,
	case when (g.groupname = ''Success'' or l.reasonid = 24) then 1 else 0 end [success]
from tblleadaudit a
join #leadauditids t on t.leadauditid = a.leadauditid
join tblleadapplicant l on l.leadapplicantid = a.leadapplicantid
join tblleadstatus s on s.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = s.statusgroupid
where a.newvalue = ' + @repid + '
order by [success] desc, leadname

drop table #leadauditids
')


end
go 