IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetLeadCallStats')
	BEGIN
		DROP  Procedure  stp_Dialer_GetLeadCallStats
	END

GO

CREATE Procedure stp_Dialer_GetLeadCallStats
@QueueId int,
@From datetime = '1/1/2000',
@To datetime = '12/31/2050'
AS
Begin

Select
[Date] = Convert(varchar(10), d.created, 111), 
[Users] = Count(distinct d.pickedupby),
[Calls] = Count(d.CallMadeId),
[Leads Called] = Count(distinct d.leadApplicantid) 
into #dialerreport
From tblleaddialerCall d with (nolock)
Where d.created between @From and @To
and d.QueueId = @QueueId 
and (d.outboundcallkey is not null) 
Group By Convert(varchar(10), d.created, 111)
Order by 1

Select
[Date] = Convert(varchar(10), d.created, 111), 
[Users] = d.pickedupby,
[UserName] = convert(varchar(255),''),
[Calls] = Count(d.CallMadeId),
[Leads Called] = Count(distinct d.leadapplicantid) 
into #dialerreportd
From tblleaddialerCall d with (nolock)
Where d.created between @From and @To
and d.QueueId = @QueueId 
and (d.outboundcallkey is not null)
and d.pickedupby is not null
Group By Convert(varchar(10), d.created, 111), d.pickedupby
Order by 1

Declare @Columns varchar(8000)
Declare @AddColumns varchar(8000)
Declare @SQL varchar(8000)
Select @Columns = stuff((Select '],[' + r.result from  tbldialercallresulttype r where r.resulttypeid not in (6,7) for xml path('')),1,2,'') + ']'
Select @AddColumns = stuff((Select '] int not null default 0; Alter Table #dialerreport Add [' + r.result from  tbldialercallresulttype r where r.resulttypeid not in (6,7) for xml path('')),1,25,'') + '] int not null default 0;'
Exec(@AddColumns)

Declare @resulttype varchar(255)
Declare resulttypes Cursor For
Select r.result from  tbldialercallresulttype r
where r.resulttypeid not in (6,7)

open resulttypes
fetch next from resulttypes into @resulttype

while @@fetch_status = 0
begin
	Select @SQL = 'update #dialerreport set ' +
	'[' + @resulttype + '] = rs.[CT]
	from #dialerreport rp with (nolock)
	inner join 
	(select 
	[Date] = convert(varchar(10),d.created, 111),
	[Result] = r.result,
	[CT] = Count(d.callmadeid) 
	from tblleaddialercall d with (nolock)
	inner join tblleaddialercallresulttype rt with (nolock) on rt.leadresulttypeid = d.resultid
	inner join tbldialercallresulttype r  with (nolock) on r.resulttypeid = rt.resulttypeid
	where d.created between ''' + convert(varchar,@From,111) + ''' and ''' + convert(varchar,@To,111) + 
	''' and d.queueid = ' + convert(varchar, @queueid) + 
	' and (d.outboundcallkey is not null) 
	and r.result = ''' + @resulttype + '''
	Group by convert(varchar(10),d.created, 111),  r.result) rs on rp.[Date] = rs.date'

	exec(@SQL)	

	fetch next from resulttypes into @resulttype
end

close resulttypes

-- Details
Select @AddColumns = stuff((Select '] int not null default 0; Alter Table #dialerreportd Add [' + r.result from  tbldialercallresulttype r where r.resulttypeid not in (6,7) for xml path('')),1,25,'') + '] int not null default 0;'
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
	[Date] = convert(varchar(10),d.created, 111),
	[UserId] = d.pickedupby,
	[Result] = r.result,
	[CT] = Count(d.callmadeid) 
	from tblleaddialercall d  with (nolock)
	inner join tblleaddialercallresulttype rt with (nolock) on rt.leadresulttypeid = d.resultid
	inner join tbldialercallresulttype r  with (nolock) on r.resulttypeid = rt.resulttypeid
	where d.created between ''' + convert(varchar,@From,111) + ''' and ''' + convert(varchar,@To,111) + 
	''' and d.queueid = ' + convert(varchar, @queueid) + 
	' and (d.outboundcallkey is not null) 
	and r.result = ''' + @resulttype + '''
	Group by convert(varchar(10),d.created, 111),  r.result, d.pickedupby) rs on rp.[Date] = rs.date and rp.users = rs.userid'

	exec(@SQL)	

	fetch next from resulttypes into @resulttype
end

close resulttypes
deallocate resulttypes

UPDATE #dialerreportd set
UserName = isnull(u.Lastname, '') + ', ' + isnull(u.firstname, '') 
from #dialerreportd d
inner join tbluser u on u.userid = d.users

select  * from #dialerreport   
order by [date]

select  * from #dialerreportd   
order by [date], [UserName] asc


drop table #dialerreportd 

drop table #dialerreport

End

GO


