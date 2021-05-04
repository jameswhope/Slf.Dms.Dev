
alter procedure stp_IncentivesInitial
(
	@RepID int
)
as
begin

	declare @sql varchar(max), @curMth int, @curYr int, @lastMth int, @lastYr int, @last datetime
	
	declare @current table
	(
		incentivemonth int,
		incentiveyear int,
		userid int,
		initialcount int,
		initialpayment money,
		initialtotal money,
		residualpayment money,
		residualcount int,
		residualtotal money,
		totalcount int,
		totalamt money,
		rep varchar(100)
	)
	
	set @curMth = month(getdate())
	set @curYr = year(getdate())
	set @last = dateadd(month,-1,getdate())
	set @lastMth = month(@last)
	set @lastYr = year(@last)

	select top 12 @sql = coalesce(@sql + ', ', '') + cast(initialcount as varchar(10)) + ' [' + datename(month,cast(incentivemonth as varchar(2))+'/1/2000') + ']'
	from tblincentives
	where userid = @RepID
	order by incentiveyear, incentivemonth
	
	if not exists (select 1 from tblincentives where userid = @RepID and incentivemonth = @lastMth and incentiveyear = @lastYr) begin
		insert @current exec stp_UnapprovedIncentives @lastMth,@lastYr,@userid=@RepID,@returndetail=0
	end	

	if not exists (select 1 from tblincentives where userid = @RepID and incentivemonth = @curMth and incentiveyear = @curYr) begin
		insert @current exec stp_UnapprovedIncentives @curMth,@curYr,@userid=@RepID,@returndetail=0	
	end
	
	if (@sql is null and (select count(*) from @current) = 1) begin
		set @sql = '0[_]'
	end
	
	select @sql = coalesce(@sql + ', ', '') + cast(initialcount as varchar(10)) + ' [' + datename(month,cast(incentivemonth as varchar(2))+'/1/2000') + ']'
	from @current

	exec('select ' + @sql)

end
go 