/****** Object:  StoredProcedure [dbo].[stp_Statistic_CaseRetention]    Script Date: 11/19/2007 15:27:44 ******/
DROP PROCEDURE [dbo].[stp_Statistic_CaseRetention]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_CaseRetention]
	(
		@dategrouping int = 2,
		@datapoints int = 9,
		@agencyid int = null,
		@attorneyid int = null
	)
 
as

declare @attorneystateid int
declare @attorneycompanyid int
--if not @attorneyid is null begin
--	set @attorneystateid=(select stateid from tblattorney where attorneyid=@attorneyid)
--	set @attorneycompanyid=(select companyid from tblattorney where attorneyid=@attorneyid)
--end

declare @crAttorney varchar(255)
set @crattorney=''

declare @crAgency varchar(255)
set @cragency=''

declare @datepart varchar(10)

if @dategrouping = 0 begin-- daily grouping
	set @datepart = 'day'
end else if @dategrouping = 1 begin-- weekly grouping
	set @datepart = 'week'
end else if @dategrouping = 2 begin-- monthly grouping
	set @datepart = 'month'
end else if @dategrouping = 3 begin-- yearly grouping
	set @datepart = 'year'
end

/*
Case retention length
*/

if not @agencyid is null 
	set @cragency=' and c.agencyid=' + convert(varchar,@agencyid)

if not @attorneyid is null 
	set @crattorney=' and c.companyid=' + convert(varchar,@attorneycompanyid) + 
					' and p.stateid=' + convert(varchar,@attorneystateid)

exec('
select top '+@datapoints+'
	''Case Retention'' as statistic,
	 count(timeafter) as [count],
	timeafter as timeunits
from
	(
	select 
		datediff
		(
			'+@datepart+',
			c.created,
			(select top 1 created from tblroadmap r where r.clientid=c.clientid and clientstatusid in (15,16,17) order by r.created desc, r.roadmapid desc)
		) as timeafter,
		c.*
	from	
		tblclient c inner join tblperson p on c.primarypersonid=p.personid
	where
		currentclientstatusid in (15,16,17)
		' + @cragency + @crattorney + '
	) t
where
	timeafter >= 0
	and timeafter < '+@datapoints+'
group by
	t.timeafter
order by
	t.timeafter asc
')
GO
