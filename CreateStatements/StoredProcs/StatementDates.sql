-- =============================================
-- Author:		Jim Hope
-- Create date: 03/16/2007
-- Update date: 08/13/2007
-- Description:	Stored Proc to generate tables for client statements
-- =============================================
	-- If running as a script use this, otherwise 
	-- use @date1 as the parameter that needs to be passed.
	declare @date1 smalldatetime
	declare @days int
	declare @CompanyID int
	declare @AccountNumber int
	
	--set @date1 = '08/15/2007'
	set @days = 15
	set @CompanyID = -1
	set @AccountNumber = -1

    -- These are variables for the process
	declare @date2 smalldatetime
	declare @day1 int
	declare @day2 int
	declare @EOM int
	declare @RealDays int
	declare @AcctNo nvarchar(255)
	declare @Name nvarchar(255)
	declare @OrigAcctNo nvarchar(255)
	declare @Status nvarchar(255)
	declare @Balance money
	declare @Amount money
	declare @From smalldatetime
	declare @To smalldatetime
	declare @SDABalance money
	declare @PFOBalance money
	declare @cid int
	declare @cslocation2 as nvarchar(255)
	declare @PmtDate1 smalldatetime
	declare @PmtDate2 smalldatetime
	declare @DepositDate nvarchar(50)
	declare @DateDiff int

	if @date1 is null
		begin
			set @date1 = getdate()
			set @DateDiff = datepart(day, @date1)
			if datepart(day, @date1) <= 15
				begin
					set @date1 = dateadd(day, -(@DateDiff - 1), @date1)
				end
			if datepart(day, @date1) >= 16
				begin
					set @DateDiff = @DateDiff - 15
					set @date1 = dateadd(day, - @DateDiff, @date1)
				end
		end

-- Statements for procedure follow
	set @day1 = datepart(day,@date1)
	set @day2 = datepart(day,@date2)

	-- Determine the To and From dates
	set @EOM = DAY(DATEADD(DAY,-1,DATEADD(MONTH,1,DATEADD(DAY,1-DAY(@date1),@date1))))
	if datepart(day, @date1) >= 15
		begin
			set @RealDays = @EOM - datepart(day, @date1)
		end
	else
		begin
			set @RealDays = @days - 1
		end

	set @date2 = dateadd(day, @realdays, @date1)
	
	-- Determine the To and From dates
	-- Start with Feb
if datepart(day, @date1) >= 15
		begin
			set @RealDays = @EOM - datepart(day, @date1)
		end
	else
		begin
			set @RealDays = @days - 1
		end

	set @date2 = dateadd(day, @realdays, @date1)
	
	-- Calculate date 2 from the count of days
	if datepart(day, @date1) = 1
		begin
		set @day1 = 16
		set @day2 = @eom
		end
	else
		begin
		set @day1 = 1
		set @day2 = 15
		end
		
	if @day1 = 1 and @eom = 31
		begin
			set @PmtDate1 = dateadd(day, 2 + (@eom - @realdays), @date1)
			set @PmtDate2 = dateadd(day, @EOM, @date1)
		end
	if @day1 = 16 and @eom = 31
		begin
			set @PmtDate1 = dateadd(day, 15, @date1)
			set @PmtDate2 = dateadd(day, 15, @PmtDate1)
		end

	if @day1 = 1 and @eom = 30
		begin
			set @PmtDate1 = dateadd(day, 1 + (@eom - @realdays), @date1)
			set @PmtDate2 = dateadd(day, @EOM, @date1)
		end
	if @day1 = 16 and @eom = 30
		begin
			set @PmtDate1 = dateadd(day, 15, @date1)
			set @PmtDate2 = dateadd(day, 14, @PmtDate1)
		end

	if @day1 = 1 and @eom = 28
		begin
			set @PmtDate1 = dateadd(day, (@eom - @realdays)-1, @date1)
			set @PmtDate2 = dateadd(day, @EOM, @date1)
		end
	if @day1 = 16 and @eom = 28
		begin
			set @PmtDate1 = dateadd(day, 15, @date1)
			set @PmtDate2 = dateadd(day, 12, @PmtDate1)
		end

if datepart(month, @date1) = 2
	begin
		if datename(day, @date2) = 28
			begin
				set @From = dateadd(month, -1, @date2)
				set @From = dateadd(day, - @realdays + 1, @From)
				set @To = dateadd(day,0, @date1)
			end
		else
			begin
				set @From = dateadd(month, -1, @date1)
				set @To = dateadd(day,-1,@date1)
			end
	end

if datepart(month, @date1) in (1,3,5,7,8,10,12)
	begin
		if datename(day, @date2) = 31
			begin
				set @From = dateadd(month, -1, @date1)
				set @From = dateadd(day, 1, @From)
				set @To = dateadd(day,0, @date1)
			end
		else
			begin
				set @From = dateadd(month, -1, @date1)
				set @To = dateadd(day,-1,@date1)
			end
	end

if datepart(month, @date1) in (4,6,9,11)
	begin
		if datename(day, @date2) = 30
			begin
				set @From = dateadd(month, -1, @date1)
				set @From = dateadd(day, 1, @From)
				set @To = @date1
			end
		else
			begin
				set @From = dateadd(month, -1, @date1)
				set @To = dateadd(day,-1,@date1)
			end
	end

	print 'End of Month:         ' + convert(varchar, @eom)
	print ''
	print 'Given Start Date:     ' + convert(varchar, @date1)
	print ''
	print 'Pmt start day:        ' + convert(varchar, @day1)
	print 'Pmt ending day:       ' + convert(varchar, @day2)
	print ''
	print 'Payment date from:    ' + convert(varchar, @PmtDate1)
	print 'Payment date to:      ' + convert(varchar, @PmtDate2)
	print ''
	print 'Transactions From:    ' + convert(varchar, @From)	
	print 'Transactions To:      ' + convert(varchar, @To)