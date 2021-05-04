IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stp_PopulateBankHolidays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[stp_PopulateBankHolidays]
GO
/*
	This stored procedure populates the tblBankHoliday table
	with proposed holiday dates for a selected range of years 
*/
CREATE PROCEDURE stp_PopulateBankHolidays
	@Year1 int,
	@Year2 int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Validate Year
	
	SELECT @Year1 = DATEPART(year, CONVERT(datetime, CONVERT(varchar, @Year1) + '-01-01', 101))
	-- If Year2 is Null then use the current year
	SELECT @Year2 = DATEPART(year, CONVERT(datetime, CONVERT(varchar,isnull(@Year2, @Year1)) + '-01-01', 101))
	-- Year2 must be equal or greater than Year1 
	IF (@Year2 < @Year1)
	BEGIN
		RAISERROR('ERROR: INVALID YEAR RANGE', 10, 1)
		RETURN
	END
	
	-- Delete existing holidays for the date range
	DELETE FROM tblBankHoliday WHERE DATEPART(year, [date]) BETWEEN @Year1 AND @Year2
	
	-- Populate tables
	DECLARE @FixedDateHoliday Table([Month] int, [Day] int, [Name] varchar(32))
	DECLARE @VarDateHoliday Table([Month] int, [Weekday] int, [Position] int, [Name] varchar(32)) 
	
	-- New Years Day, January 1
	INSERT INTO @FixedDateHoliday([Month], [Day], [Name]) VALUES(1, 1, 'New Year’s Day')
	-- Independence Day    July 4  
	INSERT INTO @FixedDateHoliday([Month], [Day], [Name]) VALUES(7, 4, 'Independence Day')
	-- Veteran’s Day    November 11		 
	INSERT INTO @FixedDateHoliday([Month], [Day], [Name]) VALUES(11, 11, 'Veteran’s Day')
	-- Christmas Day   December 25   
	INSERT INTO @FixedDateHoliday([Month], [Day], [Name]) VALUES(12, 25, 'Christmas Day')
	
	-- Weekday 1-Sun 2-Mon 3-Tue 4-Wed 5-Thu 6-Fri 7-Sat  - Assuming SET DATEFIRST 7
	-- Position -1 Last
	-- Martin L King's Birthday     3rd Monday in January   
	INSERT INTO @VarDateHoliday([Month], [Weekday], [Position], [Name]) VALUES(1, 2, 3, 'Martin Luther King, Jr. Day')       
	-- President’s Day   3rd Monday in February  Monday 
	INSERT INTO @VarDateHoliday([Month], [Weekday], [Position], [Name]) VALUES(2, 2, 3, 'President’s Day')      
	-- Memorial Day   Last Monday in May - Since Position is -1 Set the Month to the next Month
    INSERT INTO @VarDateHoliday([Month], [Weekday], [Position], [Name]) VALUES(6, 2, -1, 'Memorial Day')    
	-- Labor Day   1st Monday in September		
	INSERT INTO @VarDateHoliday([Month], [Weekday], [Position], [Name]) VALUES(9, 2, 1, 'Labor Day') 
	-- Columbus Day   2nd Monday in October		 
	INSERT INTO @VarDateHoliday([Month], [Weekday], [Position], [Name]) VALUES(10, 2, 2, 'Columbus Day') 
	-- Thanksgiving Day    4th Thursday in November  
	INSERT INTO @VarDateHoliday([Month], [Weekday], [Position], [Name]) VALUES(11, 5, 4, 'Thanksgiving Day')

	DECLARE @CurrentYear int
	SELECT @CurrentYear = @Year1

	WHILE @CurrentYear <= @Year2
	BEGIN
		-- Calculate Dates
		-- If holiday is fixed on an exact day, and it is a Satudardy the banks are open the preceding Saturday 
		-- If holiday is fixed on an exact day, and it is a Sunday the banks are closed the following Monday
		INSERT INTO tblBankHoliday([Date], [Name])
		SELECT CASE DATEPART(weekday,
							CONVERT(datetime,
								CONVERT(varchar, @CurrentYear) + '-' +
								CONVERT(varchar, [Month]) + '-' +
								CONVERT(varchar, [Day]) 
							, 101))
					/*WHEN 7 THEN 
						-- Date is Saturday. Banks are open the preceding day so don't set Friday as a Holiday.
						DATEADD(day, -1, CONVERT(datetime,
								CONVERT(varchar, @CurrentYear) + '-' +
								CONVERT(varchar, [Month]) + '-' +
								CONVERT(varchar, [Day]) 
							, 101))*/
					WHEN 1 THEN
						-- Date is Sunday. Banks are closed the following day so set Monday as a holiday
						DATEADD(day, 1, CONVERT(datetime,
								CONVERT(varchar, @CurrentYear) + '-' +
								CONVERT(varchar, [Month]) + '-' +
								CONVERT(varchar, [Day]) 
							, 101))
					ELSE
						CONVERT(datetime,
								CONVERT(varchar,@CurrentYear) + '-' +
								CONVERT(varchar,[Month]) + '-' +
								CONVERT(varchar,[Day]) 
							, 101)
				END
			AS [Date],
			[Name] 
		FROM @FixedDateHoliday
		UNION
		SELECT 
			DATEADD(wk, 
			DATEDIFF(wk, ([Position] - 1) * (-6) , 
			DATEADD(dd, 8 - [Weekday] - 
			DATEPART(day, CONVERT(datetime, CONVERT(varchar, @CurrentYear) + '-' + CONVERT(varchar, [Month]) + '-01', 101)),
						  CONVERT(datetime, CONVERT(varchar, @CurrentYear) + '-' + CONVERT(varchar, [Month]) + '-01', 101))), [Weekday] - 2) 
		AS [Date],
		[Name]
		FROM @VarDateHoliday

		-- Increment Year
		SELECT @CurrentYear = @CurrentYear + 1
	END 
END
GO

