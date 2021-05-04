
alter procedure stp_NewCreditors
as
begin

declare @sql varchar(max)

select yr, mth, datename(month,cast(cast(mth as varchar(2))+'/1/2000' as datetime)) [mthyr], cnt 
into #temp
from (
	select year(created) [yr], month(created) [mth], count(*) [cnt]
	from tblcreditor
	where created > cast(cast(month(dateadd(month,-11,getdate())) as varchar(2)) + '/1/' + cast(year(dateadd(month,-11,getdate())) as varchar(40)) as datetime)
	and (validated is null or validated = 1)
	group by year(created), month(created)
) d

select @sql = coalesce(@sql + ', ', '') + cast(cnt as varchar(10)) + ' [' + mthyr + ']'
from #temp
order by yr, mth

exec('select ' + @sql)

drop table #temp

end
go