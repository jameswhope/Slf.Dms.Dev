IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'get_IsBankHoliday')
	BEGIN
		DROP  Procedure  get_IsBankHoliday
	END

GO

CREATE PROCEDURE [get_IsBankHoliday]
(
	@date datetime
)
AS

BEGIN

SET NOCOUNT ON

SELECT
	CAST(COUNT(BankHolidayId) AS int) AS IsBankHoliday
FROM
	DMS.dbo.tblBankHoliday
WHERE
	Year(@date) = Year(Date) AND
	Month(@date) = Month(Date) AND
	Day(@date) = Day(Date)

END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

