/****** Object:  StoredProcedure [dbo].[get_IsBankHoliday]    Script Date: 11/19/2007 15:26:48 ******/
DROP PROCEDURE [dbo].[get_IsBankHoliday]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_IsBankHoliday]
(
	@date datetime
)
AS

BEGIN

SET NOCOUNT ON

SELECT
	CAST(COUNT(BankHolidayId) AS int) AS IsBankHoliday
FROM
	tblBankHoliday
WHERE
	Year(@date) = Year(Date) AND
	Month(@date) = Month(Date) AND
	Day(@date) = Day(Date)

END
GO
