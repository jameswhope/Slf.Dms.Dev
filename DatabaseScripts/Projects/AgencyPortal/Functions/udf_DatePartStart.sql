IF EXISTS (SELECT * FROM sysobjects WHERE type = 'fn' AND name = 'udf_DatePartStart')
	BEGIN
		DROP  Function  udf_DatePartStart
	END

GO
create FUNCTION udf_DatePartStart 
(
	@datepart varchar(1),
	@date datetime
)
RETURNS datetime
AS
BEGIN
	-- Return the result of the function
	RETURN CASE @datepart
					 When 'd' Then dateadd(day, datediff(day, 0, @date),0)
					 When 'w' Then dateadd(week, datediff(week, 0, @date),0)
					 When 'm' Then dateadd(month, datediff(month, 0, @date),0)
					 When 'q' Then dateadd(quarter, datediff(quarter, 0, @date),0)
				     When 'y' Then dateadd(year, datediff(year, 0, @date),0)
				   END

END

GO

