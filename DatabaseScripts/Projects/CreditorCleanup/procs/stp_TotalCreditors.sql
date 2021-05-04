
alter procedure stp_TotalCreditors
(
	@ValidatedOnly bit = 0
)
as
begin

declare @sql varchar(max)

select top 10 nocreditors, date, cast(month(date)as varchar(2))+'/'+cast(day(date)as varchar(2)) [monthday]
into #totals
from tblcreditortotals
where validatedonly = @ValidatedOnly
order by date desc

select @sql = coalesce(@sql + ', ', '') + cast(nocreditors as varchar(10)) + '[' + monthday + ']'
from #totals
order by date

exec('select ' + @sql)

drop table #totals

end
go 