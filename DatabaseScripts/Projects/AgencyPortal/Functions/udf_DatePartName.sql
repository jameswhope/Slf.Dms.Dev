IF EXISTS (SELECT * FROM sysobjects WHERE type = 'fn' AND name = 'udf_DatePartName')
	BEGIN
		DROP  Function  udf_DatePartName
	END

GO
create FUNCTION udf_DatePartName 
(
	@datepart varchar(1),
	@date datetime
)
RETURNS varchar(50)
AS
BEGIN
	-- Return the result of the function
	RETURN CASE @datepart
					 When 'd' Then CONVERT(Varchar, day(@date))--CONVERT(varchar(8), @date, 1)
					 When 'w' Then 'W' + datename(week, @date) 
					 When 'm' Then REPLACE(RIGHT(CONVERT(VARCHAR(9), @date, 6), 6), ' ', '-') 
					 When 'q' Then 'Q'+ datename(quarter, @date)
				     When 'y' Then CONVERT(Varchar, Year(@date))
				   END

END

GO


