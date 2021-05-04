IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ExpectedDeposits_GetDetail')
	BEGIN
		DROP  Procedure  stp_ExpectedDeposits_GetDetail
	END

GO

CREATE Procedure stp_ExpectedDeposits_GetDetail
(
	@clientid int,
	@enddate datetime
)
as
begin
	/*
	declare @clientid int
	declare @enddate datetime
	set @clientid = 67645
	set @enddate = '9/30/2010'
	*/

	declare @clientdepositid int, @depositday int, @depositamount money, @depositdate datetime, @curmonthyr datetime, @depositmethod varchar(20), @deposittype varchar(20), @ruleenddate datetime, @depositdatetmp varchar(20)
	declare @deposits table (clientdepositid int, depositday int, depositamount money, depositmethod varchar(20), deposittype varchar(20), ruleenddate datetime)
	declare @expected table (depositdate datetime, depositamount money, depositmethod varchar(20), deposittype varchar(20))

	insert INTO @deposits
	SELECT ClientDepositId,DepositDay,DepositAmount,DepositMethod,'Scheduled',null
	FROM tblClientDepositDay with(nolock)
	WHERE ClientDepositID not in -- exclude rules
		(
			SELECT ClientDepositID
			FROM tblDepositRuleACH with(nolock)
			WHERE StartDate <= cast(convert(varchar(10), @enddate, 101) as datetime) and
				(
					EndDate is null
					or EndDate >= cast(convert(varchar(10), @enddate, 101) as datetime)
				)
				and clientid = @clientid
		) 
		and lower(Frequency) = 'month' and DeletedDate is null and clientid = @clientid

	UNION ALL

	-- rules
	SELECT r.clientdepositid,r.depositday,r.DepositAmount,'ACH','Rule',r.EndDate
	FROM tblDepositRuleACH as r with(nolock) join tblClientDepositDay d with(nolock) on d.ClientDepositID = r.ClientDepositID
	WHERE
		r.StartDate <= cast(convert(varchar(10), @enddate, 101) as datetime) 
		and r.EndDate > cast(convert(varchar(10), getdate(), 101) as datetime)
		and lower(d.Frequency) = 'month'
		and d.DeletedDate is null
		and d.clientid = @clientid


	--select @rowCnt = count(*) from @deposits
	declare @@NextID int 
	declare @@LastID int 
	SET @@NextID = NULL

	SELECT TOP 1 @@NextID = clientdepositid FROM @deposits ORDER BY clientdepositid ASC

	WHILE NOT (@@NextID IS NULL)
	BEGIN
		/* Do your thing */
		select @clientdepositid = clientdepositid,  @depositday = depositday, @depositamount=depositamount, @depositmethod=depositmethod, @deposittype=deposittype, @ruleenddate=ruleenddate from @deposits where clientdepositid = @@NextID
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
						if @depositdate >= @curmonthyr begin
							-- check if there is an active rule for this deposit
							if not exists (select 1 from @deposits where clientdepositid = @clientdepositid and deposittype = 'Rule' and ruleenddate >= @depositdate) begin
								insert @expected values (@depositdate,@depositamount,@depositmethod,@deposittype)
							end
						end
					end
					else begin
						-- make sure the rule is valid for the current month
						if @curmonthyr < @ruleenddate begin
							insert @expected values (@depositdate,@depositamount,@depositmethod,@deposittype)
						end
					end
				end

				set @curmonthyr = dateadd(month,1,@depositdate)		
			end
			

			SET @@LastID = @@NextID
			SET @@NextID = NULL
			SELECT TOP 1 @@NextID = clientdepositid FROM @deposits WHERE clientdepositid > @@LastID ORDER BY clientdepositid ASC
		END

	insert into @expected
	SELECT DepositDate, DepositAmount, 'ACH','Adhoc'
	FROM tblAdHocACH
	WHERE (DepositDate between getdate() and @enddate) and clientid = @clientid


	-- output
	select * 
	from @expected
	order by depositdate
end

GO


GRANT EXEC ON stp_ExpectedDeposits_GetDetail TO PUBLIC

GO


