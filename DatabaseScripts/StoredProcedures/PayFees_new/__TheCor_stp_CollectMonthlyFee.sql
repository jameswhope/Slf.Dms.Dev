/****** Object:  StoredProcedure [dbo].[__TheCor_stp_CollectMonthlyFee]    Script Date: 12/19/2007 14:17:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[__TheCor_stp_CollectMonthlyFee]
	(
		@fordate datetime = null
	)

as

set nocount on
set ansi_warnings off

declare @feeday int
declare @feemonth int
declare @feeyear int

declare @lastdayofmonth bit

declare @count int

BEGIN TRY
	if @fordate is null
	begin
		set @fordate = getdate()
	end

	if @fordate = dateadd(dd, -(day(dateadd(mm, 1, @fordate))), dateadd(mm, 1, @fordate))
	begin
		set @lastdayofmonth = 1
	end
	else
	begin
		set @lastdayofmonth = 0
	end

	set @feeday = day(@fordate)
	set @feemonth = month(@fordate)
	set @feeyear = year(@fordate)

	declare @vtblMonthlyFees table
	(
		ClientID int,
		MonthlyFee money,
		MonthlyFeeDay int
	)

	INSERT INTO
		@vtblMonthlyFees
	SELECT
		ClientID,
		-MonthlyFee,
		(
			CASE
				WHEN
					MonthlyFeeDay = 0
				THEN
					1
				ELSE
					isnull(MonthlyFeeDay, 1)
			END
		) as MonthlyFeeDay
	FROM
		tblClient
	WHERE
		CurrentClientStatusID not in (15, 17, 18) and
		(
			@fordate >= MonthlyFeeStartDate
			or MonthlyFeeStartDate is null
		)
		and MonthlyFee is not null
		and not MonthlyFee = 0
		and ClientID not in
			(
				SELECT
					ClientID
				FROM
					tblRegister
				WHERE
					FeeMonth = @feemonth
					and FeeYear = @feeyear
			)

	SELECT
		@count = count(*)
	FROM
		@vtblMonthlyFees
	WHERE
		MonthlyFeeDay = @feeday or
		(
			@lastdayofmonth = 1
			and MonthlyFeeDay >= @feeday
		)

	INSERT INTO
		tblRegister
		(
			ClientID,
			TransactionDate,
			Amount,
			EntryTypeID,
			[Description],
			FeeMonth,
			FeeYear
		)
	SELECT
		ClientID,
		@fordate,
		MonthlyFee,
		1,
		'Maintenance Fee for ' + cast(datename(mm, @fordate) as nvarchar(15)) + ' ' + cast(@feeyear as nvarchar(5)),
		@feemonth,
		@feeyear
	FROM
		@vtblMonthlyFees
	WHERE
		MonthlyFeeDay = @feeday or
		(
			@lastdayofmonth = 1
			and MonthlyFeeDay >= @feeday
		)

	print cast(@count as nvarchar(10)) + ' total maintenance fees were assessed'
END TRY
BEGIN CATCH
	declare @errorMessage nvarchar(MAX) set @errorMessage = ERROR_MESSAGE()
	declare @errorSeverity int set @errorSeverity = ERROR_SEVERITY()
	declare @errorState int set @errorState = ERROR_STATE()

	RAISERROR(@errorMessage, @errorSeverity, @errorState)
END CATCH