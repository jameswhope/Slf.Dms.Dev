IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CloserSuccessRate')
	DROP  Procedure  stp_CloserSuccessRate
GO

create procedure stp_CloserSuccessRate
(
	@repid int,
	@monthsago int = -8
)
as
begin
-- Change History:
-- 9/21/10	john		Include refund(free) leads.

declare @usergroupid int, @sql varchar(100)

select @usergroupid = usergroupid
from tbluser
where userid = @repid

if @usergroupid = 25
	set @sql = ' and u.usergroupid in (25) -- CID Closers'
else
	set @sql = ' and u.usergroupid in (1,24,26,28,29) -- CID Fronters'


exec('
declare @start datetime

set @start = dateadd(month,' + @monthsago + ',getdate())
set @start = cast(cast(month(@start) as varchar(2)) + ''/1/'' + cast(year(@start) as varchar(4)) as datetime)

-- get closers for the month
select min(a.leadauditid) [leadauditid]
into #leadauditids
from tblleadapplicant l
join tblLeadAudit a on a.leadapplicantid = l.leadapplicantid
	and a.leadfield = ''RepID''
join tblUser u on u.userid = a.newvalue'
	+ @sql + '
where l.created >= @start
group by l.leadapplicantid

-- output
select 
	datename(month,l.created) + '' '' + cast(year(l.created) as char(4)) [monthyr],
	month(l.created) [mth], year(l.created) [yr], 
	count(*) [leads], 
	sum(case when (g.groupname = ''Success'' or l.reasonid = 24) then 1 else 0 end) [success],
	sum(case when (g.groupname = ''Success'' or l.reasonid = 24) then 1 else 0 end) / cast(count(*) as money) [pct]
from tblleadaudit a
join #leadauditids t on t.leadauditid = a.leadauditid
join tblleadapplicant l on l.leadapplicantid = a.leadapplicantid
join tblleadstatus s on s.statusid = l.statusid
join tblleadstatusgroup g on g.statusgroupid = s.statusgroupid
where a.newvalue = ' + @repid + '
group by datename(month,l.created), month(l.created), year(l.created)
order by [yr] desc, [mth] desc

drop table #leadauditids
')


end
go