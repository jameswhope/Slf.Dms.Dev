if exists (select 1 from sysobjects where name = 'stp_ExpectedDeposits') begin
	drop procedure stp_ExpectedDeposits
end
go

create procedure stp_ExpectedDeposits
(
	@clientid int,
	@enddate datetime
)
as
begin

	declare @clientdepositid int, @depositday int, @depositamount money, @depositdate datetime, @curmonthyr datetime, @depositmethod varchar(20), @deposittype varchar(20), @rulestartdate datetime, @ruleenddate datetime, @depositdatetmp varchar(20), @depositstartdate datetime, @ruleachid int
	declare @deposits table (row int, clientdepositid int, depositday int, depositamount money, depositmethod varchar(20), deposittype varchar(20), rulestartdate datetime, ruleenddate datetime, ruleachid int)
	declare @expected table (depositdate datetime, depositamount money, depositmethod varchar(20), deposittype varchar(20), ID int)


	select @depositstartdate = isnull(depositstartdate,'1/1/1900')
	from tblclient
	where clientid = @clientid
	
	
	insert INTO @deposits
	select row_number() over (order by ClientDepositId,DepositDay) [row], ClientDepositId,DepositDay,DepositAmount,DepositMethod,[type],startdate,enddate,ruleachid
	from (
		SELECT ClientDepositId,DepositDay,DepositAmount,DepositMethod,'Scheduled' [type],null [startdate],null [enddate],null [ruleachid]
		FROM tblClientDepositDay with(nolock)
		WHERE lower(Frequency) = 'month' and DeletedDate is null and clientid = @clientid

		UNION ALL

		-- rules
		SELECT r.clientdepositid,r.depositday,r.DepositAmount,'ACH','Rule',r.StartDate,r.EndDate,r.ruleachid
		FROM tblDepositRuleACH as r with(nolock) 
		JOIN tblClientDepositDay d with(nolock) on d.ClientDepositID = r.ClientDepositID
		WHERE
			r.StartDate <= cast(convert(varchar(10), @enddate, 101) as datetime) 
			and r.EndDate > cast(convert(varchar(10), getdate(), 101) as datetime)
			and lower(d.Frequency) = 'month'
			and d.DeletedDate is null
			and d.clientid = @clientid
	) d


	--select @rowCnt = count(*) from @deposits
	declare @@NextRow int 
	declare @@LastRow int 
	SET @@NextRow = NULL

	SELECT TOP 1 @@NextRow = row FROM @deposits ORDER BY row ASC

	WHILE NOT (@@NextRow IS NULL)
	BEGIN
		/* Do your thing */
		select @clientdepositid = clientdepositid,  @depositday = depositday, @depositamount=depositamount, @depositmethod=depositmethod, @deposittype=deposittype, @rulestartdate=rulestartdate, @ruleenddate=ruleenddate, @ruleachid=ruleachid
		from @deposits 
		where row = @@NextRow
		
		set @curmonthyr = getdate() -- reset
		
		-- deposits expected between now and the settlement due date
		while @curmonthyr <= @enddate
			begin
				set @depositdatetmp = cast(month(@curmonthyr) as varchar(2)) + '/' + cast(@depositday as varchar(2)) + '/' + cast(year(@curmonthyr) as varchar(4))
				
				if isdate(@depositdatetmp) = 1 begin
					set @depositdate = cast(@depositdatetmp as datetime) 
				end
				else begin
					-- set to last day of the month
					set @depositdatetmp = cast(month(@curmonthyr) as varchar(2)) + '/1/' + cast(year(@curmonthyr) as varchar(4))
					set @depositdate = dateadd(day,-1,dateadd(month,1,@depositdatetmp))
				end

				if (@depositamount > 0) and (@depositdate > getdate()) and (@depositdate <= @enddate) begin
					if @deposittype = 'Scheduled' begin
						if (@depositdate >= @curmonthyr) and (@depositdate >= @depositstartdate) begin
							-- check if there is an active rule for this deposit
							if not exists (select 1 from @deposits where clientdepositid = @clientdepositid and deposittype = 'Rule' and (@depositdate between rulestartdate and ruleenddate) ) begin
								insert @expected values (@depositdate,@depositamount,@depositmethod,@deposittype,@clientdepositid)
							end
						end
					end
					else begin
						-- make sure the rule is valid for the current month
						if (@curmonthyr between @rulestartdate and @ruleenddate) begin
							insert @expected values (@depositdate,@depositamount,@depositmethod,@deposittype,isnull(@ruleachid,@clientdepositid))
						end
					end
				end

				set @curmonthyr = dateadd(month,1,@depositdate)		
			end
			

			SET @@LastRow = @@NextRow
			SET @@NextRow = NULL
			SELECT TOP 1 @@NextRow = row FROM @deposits WHERE row > @@LastRow ORDER BY row ASC
		END

	insert into @expected
	SELECT DepositDate, DepositAmount, 'ACH','Adhoc', AdhocACHID
	FROM tblAdHocACH
	WHERE (DepositDate between getdate() and @enddate) and clientid = @clientid



	-- output
	select isnull(sum(depositamount),0) [expectedamount], count(*) [numdeposits]
	from @expected

	select * 
	from @expected
	order by depositdate

end
go 