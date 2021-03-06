/****** Object:  StoredProcedure [dbo].[stp_Statistic_ClientGrouped]    Script Date: 11/19/2007 15:27:45 ******/
DROP PROCEDURE [dbo].[stp_Statistic_ClientGrouped]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_Statistic_ClientGrouped]
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


declare @crAgency varchar(255)
set @cragency=''
declare @crattorney varchar(255)
set @crattorney=''



declare @datefield varchar (500)
declare @datefield2 varchar (500)
declare @field varchar(50)
set @field='r.transactiondate'
declare @field2 varchar(50)
set @field2='c.created'
declare @datepart varchar(10)

if @dategrouping = 0 begin-- daily grouping
	set @datefield = 'convert(datetime, convert(varchar, ' + @field + ', 101))'
	set @datefield2 = 'convert(datetime, convert(varchar, ' + @field2 + ', 101))'
	set @datepart = 'day'
end else if @dategrouping = 1 begin-- weekly grouping
	set @datefield = 'dateadd(day, 1 - datepart(dw, ( convert(varchar, ' + @field + ', 101) )), ( convert(varchar, ' + @field + ', 101) ))'
	set @datefield2 = 'dateadd(day, 1 - datepart(dw, ( convert(varchar, ' + @field2 + ', 101) )), ( convert(varchar, ' + @field2 + ', 101) ))'
	set @datepart = 'week'
end else if @dategrouping = 2 begin-- monthly grouping
	set @datefield = 'convert(datetime, convert(varchar(2), month(' + @field + ')) + N''/1/'' + convert(varchar(4), year(' + @field + ')))'
	set @datefield2 = 'convert(datetime, convert(varchar(2), month(' + @field2 + ')) + N''/1/'' + convert(varchar(4), year(' + @field2 + ')))'
	set @datepart = 'month'
end else if @dategrouping = 3 begin-- yearly grouping
	set @datefield = 'convert(datetime, N''1/1/'' + convert(varchar(12), year(' + @field + ')))'
	set @datefield2 = 'convert(datetime, N''1/1/'' + convert(varchar(12), year(' + @field2 + ')))'
	set @datepart = 'year'
end

/*
Commitments
*/

if not @agencyid is null 
	set @cragency=' and nc.agencyid=' + convert(varchar,@agencyid)

if not @attorneyid is null 
	set @crattorney=' and nc.companyid=' + convert(varchar,@attorneycompanyid) + 
					' and p.stateid=' + convert(varchar,@attorneystateid)

exec('

select top '+@datapoints+'
	''Commitments'' as statistic,
	count(timeago) as [count],
	timeago as timeunits
from
(
	select
		datediff
		(
			'+@datepart+',
			'+@datefield2+',
			getdate()
		) as timeago,
		('+@datefield2+') as created
	from
		(
		select
			(select top 1 created from tblroadmap nr where nr.clientid=nc.clientid and clientstatusid=5 order by nr.created asc, nr.roadmapid asc) as created,
			nc.currentclientstatusid,
			nc.clientid
		from
			tblclient nc inner join
			tblperson p on nc.primarypersonid=p.personid
		where
			not nc.created is null
		' + @cragency + @crattorney + '
		) c

) t
where
	timeago >= 0
	and timeago < '+@datapoints+'
group by
	t.timeago,t.created
order by 
	t.created desc
')


/*
Completions
*/
if not @agencyid is null 
	set @cragency=' and nc.agencyid=' + convert(varchar,@agencyid)

if not @attorneyid is null 
	set @crattorney=' and nc.companyid=' + convert(varchar,@attorneycompanyid) + 
					' and p.stateid=' + convert(varchar,@attorneystateid)

exec('
select top '+@datapoints+'
	''Completions'' as statistic,
	count(timeago) as [count],
	timeago as timeunits
from
(
	select
		datediff
		(
			'+@datepart+',
			'+@datefield2+',
			getdate()
		) as timeago,
		('+@datefield2+') as created
	from
		(
		select
			(select top 1 created from tblroadmap nr where nr.clientid=nc.clientid and clientstatusid=18 order by nr.created desc, nr.roadmapid desc) as created,
			nc.currentclientstatusid,
			nc.clientid
		from
			tblclient nc inner join
			tblperson p on nc.primarypersonid=p.personid
		where
			not nc.created is null
			and nc.currentclientstatusid=18
		' + @cragency + @crattorney + '
		) c

) t
where
	timeago >= 0
	and timeago < '+@datapoints+'
group by
	t.timeago,t.created
order by 
	t.created desc
')

/*
New cases
*/
if not @agencyid is null 
	set @cragency=' and c.agencyid=' + convert(varchar,@agencyid)

if not @attorneyid is null 
	set @crattorney=' and c.companyid=' + convert(varchar,@attorneycompanyid) + 
					' and p.stateid=' + convert(varchar,@attorneystateid)

exec('

select top '+@datapoints+'
	''New Cases'' as statistic,
	count(timeago) as [count],
	timeago as timeunits
from
(
	select
		datediff
		(
			'+@datepart+',
			'+@datefield2+',
			getdate()
		) as timeago,
		('+@datefield2+') as created
	from
		tblclient c inner join
		tblperson p on c.primarypersonid=p.personid
	where
		1=1 ' + @cragency + @crattorney + '
) t
where
	timeago >= 0
	and timeago < '+@datapoints+'
group by
	t.timeago,t.created
order by 
	t.created desc
')


/*
Cancellations
*/

if not @agencyid is null 
	set @cragency=' and nc.agencyid=' + convert(varchar,@agencyid)

if not @attorneyid is null 
	set @crattorney=' and nc.companyid=' + convert(varchar,@attorneycompanyid) + 
					' and p.stateid=' + convert(varchar,@attorneystateid)

exec('

select top '+@datapoints+'
	''Cancellations'' as statistic,
	count(timeago) as [count],
	timeago as timeunits
from
(
	select
		datediff
		(
			'+@datepart+',
			'+@datefield2+',
			getdate()
		) as timeago,
		('+@datefield2+') as created
	from
		(
		select
			(select top 1 created from tblroadmap nr where nr.clientid=nc.clientid and clientstatusid=17 order by nr.created desc, nr.roadmapid desc) as created,
			nc.currentclientstatusid,
			nc.clientid
		from
			tblclient nc inner join
			tblperson p on nc.primarypersonid=p.personid
		where
			nc.currentclientstatusid=17
			and not nc.created is null
		' + @cragency + @crattorney + '
		) c
		
) t
where
	timeago >= 0
	and timeago < '+@datapoints+'
group by
	t.timeago,t.created
order by 
	t.created desc
')
GO
