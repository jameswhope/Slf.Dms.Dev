IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetCallStats')
	BEGIN
		DROP  Procedure  stp_Dialer_GetCallStats
	END

GO

CREATE Procedure stp_Dialer_GetCallStats
@ReasonId int,
@From datetime = '1/1/2000',
@To datetime = '12/31/2050'
AS
Begin
Select
[Date] = Convert(varchar(10), d.started, 111), 
[Users] = Count(distinct d.answeredby),
[Calls] = Count(d.CallMadeId),
[Clients Called] = Count(distinct d.clientid),
[Matters Called] = 0
into #dialerreport
From tbldialerCall d with (nolock)
Where d.started between @From and @To
and d.ReasonId = @ReasonId 
and (d.outboundcallkey is not null or (d.outboundcallkey is null and d.started < '10/20/2010')) 
Group By Convert(varchar(10), d.started, 111)
Order by 1

Select
[Date] = Convert(varchar(10), d.started, 111), 
[Users] = d.answeredby,
[UserName] = convert(varchar(255),''),
[Calls] = Count(d.CallMadeId),
[Clients Called] = Count(distinct d.clientid),
[Matters Called] = 0
into #dialerreportd
From tbldialerCall d with (nolock)
Where d.started between @From and @To
and d.ReasonId = @ReasonId 
and (d.outboundcallkey is not null or (d.outboundcallkey is null and d.started < '10/20/2010')) 
and d.answeredby is not null
Group By Convert(varchar(10), d.started, 111), d.answeredby
Order by 1

update #dialerreport set
[matters called] = mc.matters
from #dialerreport rp with (nolock)
inner join
(select 
[Date] = Convert(varchar(10), m.created, 111),
[Matters] = Count(distinct m.matterid)
from tblmatterdialerlog m with (nolock)
inner join tbldialercall d on d.callmadeid = m.primarycallmadeid
Where m.reasonid = @reasonid
and (d.outboundcallkey is not null or (d.outboundcallkey is null and d.started < '10/20/2010')) 
group by Convert(varchar(10), m.created, 111)) mc on rp.date = mc.date

update #dialerreportd set
[matters called] = mc.matters
from #dialerreportd rp with (nolock)
inner join
(select 
[Date] = Convert(varchar(10), m.created, 111),
[Matters] = Count(distinct m.matterid),
userid = d.answeredby
from tblmatterdialerlog m with (nolock)
inner join tbldialercall d with (nolock) on d.callmadeid = m.primarycallmadeid
Where m.reasonid = @reasonid
and (d.outboundcallkey is not null or (d.outboundcallkey is null and d.started < '10/20/2010')) 
group by Convert(varchar(10), m.created, 111), d.answeredby) mc on rp.date = mc.date and rp.users = mc.userid 
 
Declare @Columns varchar(8000)
Declare @AddColumns varchar(8000)
Declare @SQL varchar(8000)
Select @Columns = stuff((Select '],[' + r.result from  tbldialercallresulttype r where r.resulttypeid not in (7,9) for xml path('')),1,2,'') + ']'
Select @AddColumns = stuff((Select '] int not null default 0; Alter Table #dialerreport Add [' + r.result from  tbldialercallresulttype r where r.resulttypeid not in (7,9) for xml path('')),1,25,'') + '] int not null default 0;'
Exec(@AddColumns)

/*
Select @SQL = 'Select [Date], ' + @Columns + 
' From (select 
[Date] = convert(varchar(10),d.started, 111),
[Result] = r.result,
d.callmadeid  
from tbldialercall d
inner join tbldialercallresulttype r on r.resulttypeid = d.resultid
where d.started between ''' + convert(varchar, @From, 111) + ''' and  ''' + convert(varchar, @To, 111) + '''' +
' and d.reasonid = ' + convert(varchar, @reasonId) + ' and d.outboundcallkey is not null
) t PIVOT
(Count(CallMadeId) For Description IN (' + @Columns + ') as pvt Order by [Date];'
*/

Declare @resulttype varchar(255)
Declare resulttypes Cursor For
Select r.result from  tbldialercallresulttype r
where r.resulttypeid not in (7,9)

open resulttypes
fetch next from resulttypes into @resulttype

while @@fetch_status = 0
begin
	Select @SQL = 'update #dialerreport set ' +
	'[' + @resulttype + '] = rs.[CT]
	from #dialerreport rp with (nolock)
	inner join 
	(select 
	[Date] = convert(varchar(10),d.started, 111),
	[Result] = r.result,
	[CT] = Count(d.callmadeid) 
	from tbldialercall d with (nolock)
	inner join tbldialercallresulttype r  with (nolock) on r.resulttypeid = d.resultid
	where d.started between ''' + convert(varchar,@From,111) + ''' and ''' + convert(varchar,@To,111) + 
	''' and d.reasonid = ' + convert(varchar, @reasonid) + 
	' and (d.outboundcallkey is not null or (d.outboundcallkey is null and d.started < ''10/20/2010'')) 
	and r.result = ''' + @resulttype + '''
	Group by convert(varchar(10),d.started, 111),  r.result) rs on rp.[Date] = rs.date'

	exec(@SQL)	

	fetch next from resulttypes into @resulttype
end

close resulttypes

-- Details
Select @AddColumns = stuff((Select '] int not null default 0; Alter Table #dialerreportd Add [' + r.result from  tbldialercallresulttype r where r.resulttypeid not in (7,9) for xml path('')),1,25,'') + '] int not null default 0;'
Exec(@AddColumns)

open resulttypes
fetch next from resulttypes into @resulttype

while @@fetch_status = 0
begin
	Select @SQL = 'update #dialerreportd set ' +
	'[' + @resulttype + '] = rs.[CT]
	from #dialerreportd  rp  with (nolock)
	inner join 
	(select 
	[Date] = convert(varchar(10),d.started, 111),
	[UserId] = d.answeredby,
	[Result] = r.result,
	[CT] = Count(d.callmadeid) 
	from tbldialercall d  with (nolock)
	inner join tbldialercallresulttype r  with (nolock) on r.resulttypeid = d.resultid
	where d.started between ''' + convert(varchar,@From,111) + ''' and ''' + convert(varchar,@To,111) + 
	''' and d.reasonid = ' + convert(varchar, @reasonid) + 
	' and (d.outboundcallkey is not null or (d.outboundcallkey is null and d.started < ''10/20/2010'')) 
	and r.result = ''' + @resulttype + '''
	Group by convert(varchar(10),d.started, 111),  r.result, d.answeredby) rs on rp.[Date] = rs.date and rp.users = rs.userid'

	exec(@SQL)	

	fetch next from resulttypes into @resulttype
end

close resulttypes
deallocate resulttypes

--Extras
--Specific Dialer Info
if @ReasonId = 1
begin
	--Dialer Verbals
	Alter Table #dialerreport Add Verbals int not null default 0;
	--Add Values
	Update #dialerreport Set
	Verbals = v.verbals
	from #dialerreport d  with (nolock)
	inner join 
	(select 
	[Date] = convert(varchar(10),rc.startDate,111),
	[Verbals] = count(rc.settlementrecid) 
	from tblsettlementrecordedcall rc  with (nolock)
	where rc.startDate between @From and @To
	and rc.completed = 1
	Group BY convert(varchar(10),rc.startDate,111)) v on v.[date] = d.[date]
	
	insert into #dialerreport(Date, [Users], [Calls], [Clients Called], [Matters Called], Verbals)
	select 
	[Date] = convert(varchar(10),rc.startDate,111),
	0, 0, 0, 0,
	[Verbals] = count(rc.settlementrecid) 
	from tblsettlementrecordedcall rc  with (nolock)
	where rc.startDate between @From and @To
	and rc.completed = 1
	Group BY convert(varchar(10),rc.startDate,111) 
	except 
	Select Date, 0, 0, 0, 0, Verbals  from #dialerreport   

	--Dialer Verbals
	Alter Table #dialerreportd Add Verbals int not null default 0;
	--Add Values
	Update #dialerreportd Set
	Verbals = v.verbals
	from #dialerreportd d  with (nolock)
	inner join 
	(select 
	[Date] = convert(varchar(10),rc.startDate,111),
	[Verbals] = count(rc.settlementrecid),
	[UserId] = rc.executedby 
	from tblsettlementrecordedcall rc  with (nolock)
	where rc.startDate between @From and @To
	and rc.completed = 1
	Group BY convert(varchar(10),rc.startDate,111), rc.executedby) v on v.[date] = d.[date] and v.userid = d.users

	insert into #dialerreportd([Date], [UserName], [Calls], [Clients Called], [Matters Called], Verbals, Users)
	select 
	[Date] = convert(varchar(10),rc.startDate,111),
	'',	0, 0, 0,
	[Verbals] = count(rc.settlementrecid),
	[UserId] = rc.executedby 
	from tblsettlementrecordedcall rc  with (nolock)
	where rc.startDate between @From and @To
	and rc.completed = 1
	Group BY convert(varchar(10),rc.startDate,111), rc.executedby 
	except 
	Select [Date], '', 0, 0, 0, Verbals, Users from #dialerreportd 
end

UPDATE #dialerreportd set
UserName = isnull(u.Lastname, '') + ', ' + isnull(u.firstname, '') 
from #dialerreportd d
inner join tbluser u on u.userid = d.users

select  * from #dialerreport   
order by [date]

if @ReasonId = 1
select  * from #dialerreportd   
order by [date], [Verbals] desc, [UserName] asc
else
select  * from #dialerreportd   
order by [date], [UserName] asc



drop table #dialerreportd 

drop table #dialerreport

	
End


GO



