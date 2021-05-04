IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_cid_getConversionMatrixData')
	BEGIN
		DROP  Procedure  stp_cid_getConversionMatrixData
	END

GO

CREATE Procedure stp_cid_getConversionMatrixData
(
	@startdate datetime = null
)
as
BEGIN

	--declare @startdate datetime

	declare @lasthr int
	declare @firstHr int

	set @firstHr = 5
	set @lasthr = 23

	if @startdate is null
		BEGIN
			IF (SELECT DATENAME(WEEKDAY, getdate())) = 'Monday'
				BEGIN
					set @startdate = convert(varchar(10),dateadd(d,-2,getdate()),101)
				END
			else		
				BEGIN
					set @startdate = convert(varchar(10),dateadd(d,-1,getdate()),101)
				END
		END
	
	delete from tblConversionMatrix where eventdate = @startdate

	declare @sqlCallData varchar(max)
	declare @sqlMatrixSelectData varchar(max)
	declare @sqlMatrixFromData varchar(max)
	declare @sqlMatrixWhereData varchar(max)
	declare @sql varchar(max)
	declare @sql2 varchar(max)

	set @sqlCallData = ('declare @tblcalldetail table (callid varchar(50),CallDurationSeconds numeric,HoldDurationSeconds numeric,LineDurationSeconds numeric)') + char(13)
	set @sqlCallData = @sqlCallData + 'insert into @tblcalldetail '+ char(13)
	set @sqlCallData = @sqlCallData + 'select callid,CallDurationSeconds ,HoldDurationSeconds ,LineDurationSeconds '+ char(13)
	set @sqlCallData = @sqlCallData + 'from [DMF-SQL-0001].i3_cic.dbo.calldetail cd with(READPAST) '+ char(13)
	set @sqlCallData = @sqlCallData + 'where convert(varchar(12),initiateddate,101) = ' + char(39) + convert(varchar(12),@startDate,101) + char(39) + ' '
	set @sqlCallData = @sqlCallData + 'option (fast 1000) ' + char(13)+ char(13)

	set @sqlMatrixSelectData = 'insert into tblConversionMatrix '+ char(13)
	set @sqlMatrixSelectData = @sqlMatrixSelectData + 'SELECT [EventDate] = convert(varchar(10),eventdate,101),[EventBy] =uc.firstname + '' '' + uc.lastname '  + char(13)
	set @sqlMatrixSelectData = @sqlMatrixSelectData + ', EventName, [TotalCalls] = count(*), [TotalCallDurationSeconds] = sum(CallDurationSeconds) '  + char(13)
	set @sqlMatrixSelectData = @sqlMatrixSelectData + ', [AvgCallDurationSeconds] = avg(CallDurationSeconds), [TotalTransferred] = sum(case when eventname = ''transfer'' then 1 else 0 end)' + char(13)
	set @sql = ''
	set @sql2 = ''
	while @firstHr < @lastHr
		BEGIN
			if @firstHr < 13
				BEGIN
					set @sql = @sql + ', [TotalCalls_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then 1 else 0 end)' + char(13)
					set @sql = @sql + ', [TotalCallDurationSeconds_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then CallDurationSeconds else 0 end)'+ char(13)
					set @sql = @sql + ', [AvgCallDurationSeconds_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then CallDurationSeconds else 0 end)/isnull(NULLIF(sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then 1 else 0 end),0),1)'+ char(13)
					set @sql = @sql + ', [Transferred_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' and eventname = ''transfer'' then 1 else 0 end) '
				END
			else
				BEGIN
					set @sql2 = @sql2 + ', [TotalCalls_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then 1 else 0 end)' + char(13)
					set @sql2 = @sql2 + ', [TotalCallDurationSeconds_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then CallDurationSeconds else 0 end)'+ char(13)
					set @sql2 = @sql2 + ', [AvgCallDurationSeconds_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then CallDurationSeconds else 0 end)/isnull(NULLIF(sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' then 1 else 0 end),0),1)'+ char(13)
					set @sql2 = @sql2 + ', [Transferred_' + convert(varchar,@firstHr) + 'A] = sum(case when datepart(hour,eventdate) = ' + convert(varchar,@firstHr) + ' and eventname = ''transfer'' then 1 else 0 end) '
				END
			
			set @firstHr = @firstHr + 1
		END
	set @sqlMatrixFromData = 'FROM tblCallLog cl with(nolock) ' + char(13)
	set @sqlMatrixFromData = @sqlMatrixFromData + 'inner join @tblcalldetail cd on cd.callid = cl.CallIdKey ' + char(13)
	set @sqlMatrixFromData = @sqlMatrixFromData + 'inner join tbluser uc with(READPAST) on uc.userid = cl.eventby ' + char(13)
	set @sqlMatrixFromData = @sqlMatrixFromData + 'left join tblleadapplicant la with(READPAST) on la.callidkey = cl.CallIdKey ' + char(13)
	set @sqlMatrixWhereData = 'where convert(varchar(12),eventdate,101) = ' + char(39) + convert(varchar(12),@startDate,101) + char(39) + ' ' + char(13)
	set @sqlMatrixWhereData = @sqlMatrixWhereData + 'and eventname in (''makecall'',''disconnect'',''pickup'', ''transfer'') ' + char(13)
	set @sqlMatrixWhereData = @sqlMatrixWhereData + 'and phonenumber is not null ' + char(13)
	set @sqlMatrixWhereData = @sqlMatrixWhereData + 'and (eventby in (select userid from tbluser where usergroupid in (select usergroupid from tblusergroup where name like ''Client Int%'')) or eventby in (977,925,1451) ) ' + char(13)
	set @sqlMatrixWhereData = @sqlMatrixWhereData + 'group by convert(varchar(10),eventdate,101), uc.firstname, uc.lastname, EventName '  + char(13)
	set @sqlMatrixWhereData = @sqlMatrixWhereData + 'order by eventdate, uc.firstname, uc.lastname, EventName '  + char(13)
	set @sqlMatrixWhereData = @sqlMatrixWhereData + 'option (fast 100)'
	
	
	--print(@sqlCallData + ' ' + @sqlMatrixSelectData + ' ' + @sql + ' ' +  @sql2 + ' ' +  @sqlMatrixFromData + ' ' +  @sqlMatrixWhereData)
	exec(@sqlCallData + ' ' + @sqlMatrixSelectData + ' ' + @sql + ' ' +  @sql2 + ' ' +  @sqlMatrixFromData + ' ' +  @sqlMatrixWhereData)
end


GO


GRANT EXEC ON stp_cid_getConversionMatrixData TO PUBLIC

GO


