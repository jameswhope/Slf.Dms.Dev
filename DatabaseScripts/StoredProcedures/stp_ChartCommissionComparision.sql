/****** Object:  StoredProcedure [dbo].[stp_ChartCommissionComparision]    Script Date: 11/19/2007 15:26:55 ******/
DROP PROCEDURE [dbo].[stp_ChartCommissionComparision]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_ChartCommissionComparision]
(
	@startdate datetime=null,
	@enddate datetime=null,
	@groupby int = 0,
	@splitby int = 2,
	@commrecids varchar(500) = null,
	@commrecidsop varchar(5) = null
)
as

create table #commrecids (commrecid int)
if @commrecids is null begin
	insert into #commrecids(commrecid) select commrecid from tblcommrec
end else begin
	exec ('insert into #commrecids(commrecid) 
			select commrecid from tblcommrec 
			where ' + @commrecidsop + ' commrecid in (' + @commrecids + ')'
	)
end


declare @groupstr varchar(500)
declare @splitstr varchar(500)
declare @field varchar(50)
set @field='batchdate'

if @groupby = 0 begin -- daily grouping
	if @splitby = 1 begin --day of week
		set @groupstr = 'datepart(dw,' + @field + ')'
	end else if @splitby = 2 begin --day of month
		set @groupstr = 'day(' + @field + ')'
	end else if @splitby = 3 begin --day of year
		set @groupstr = 'datepart(dy,' + @field + ')'
	end
end else if @groupby = 1 begin -- weekly grouping
	if @splitby = 2 begin --week of month
		set @groupstr = 'dbo.monthweek(' + @field + ')'
	end else if @splitby = 3 begin --week of year
		set @groupstr = 'datepart(wk,' + @field + ')'
	end
end else if @groupby = 2 begin -- monthly grouping
	if @splitby = 3 begin--month of year
		set @groupstr = 'month(' + @field + ')'
	end
end

set @groupstr = 'convert(int,' + @groupstr + ')'

if @splitby = 1 begin -- weekly grouping
	set @splitstr = 'dateadd(day, 1 - datepart(dw, ( convert(varchar, ' + @field + ', 101) )), ( convert(varchar, ' + @field + ', 101) ))'
end else if @splitby = 2 begin -- monthly grouping
	set @splitstr = 'convert(datetime, convert(varchar(2), month(' + @field + ')) + N''/1/'' + convert(varchar(4), year(' + @field + ')))'
end else if @splitby = 3 begin -- yearly grouping
	set @splitstr = 'convert(datetime, N''1/1/'' + convert(varchar(12), year(' + @field + ')))'
end

declare @sql varchar(8000)

set @sql = 
'select 
	' + @groupstr + ' as [group],
	' + @splitstr + ' as splitdate,
	sum(amount) as amount
from


(
select 
	batchdate,
	cp.amount
from
	tblcommbatch cb
	inner join tblcommpay cp on cp.commbatchid=cb.commbatchid
	inner join tblcommstruct cst on cp.commstructid=cst.commstructid 
where commrecid in (select commrecid from #commrecids) '

if @startdate is not null
	set @sql = @sql + ' and CAST(CONVERT(char(10), cb.BatchDate, 101) AS datetime) >= ''' + convert(varchar, @startdate) + ''''

if @enddate is not null 
	set @sql = @sql + ' and CAST(CONVERT(char(10), cb.BatchDate, 101) AS datetime) <= ''' +  convert(varchar, @enddate) + ''''


set @sql = @sql + 
' UNION ALL '

--chargebacks

set @sql = @sql + 
'SELECT 
	batchdate,
	cp.amount
FROM 
	tblCommBatch cb INNER JOIN 
	(SELECT [Percent],CommChargeBackId,CommPayID,ChargeBackDate,RegisterPaymentId,CommStructID,-Amount as Amount,CommBatchId FROM tblCommChargeBack) cp on cb.CommBatchId=cp.CommBatchId INNER JOIN 
	tblCommStruct cs ON cp.CommStructId=cs.CommStructId 
WHERE
	commrecid in (select commrecid from #commrecids) '

if @startdate is not null
	set @sql = @sql + ' and CAST(CONVERT(char(10), cb.BatchDate, 101) AS datetime) >= ''' + convert(varchar, @startdate) + ''''

if @enddate is not null 
	set @sql = @sql + ' and CAST(CONVERT(char(10), cb.BatchDate, 101) AS datetime) <= ''' +  convert(varchar, @enddate) + ''''

set @sql = @sql +
') t '

set @sql=@sql + '
group by
   ' + @splitstr + ', ' + @groupstr + '
order by
   ' + @splitstr + ', ' + @groupstr


print(@sql)
exec(@sql)
GO
