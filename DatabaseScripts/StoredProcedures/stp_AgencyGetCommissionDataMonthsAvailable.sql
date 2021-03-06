/****** Object:  StoredProcedure [dbo].[stp_AgencyGetCommissionDataMonthsAvailable]    Script Date: 11/19/2007 15:26:51 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetCommissionDataMonthsAvailable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetCommissionDataMonthsAvailable]
(
	@agencyId int
)

AS

SET NOCOUNT ON

DECLARE @clientIds TABLE
(
	ClientId int
)

INSERT INTO
	@clientIds
SELECT
	ClientId
FROM
	tblClient
WHERE
	AgencyId=@agencyId

SELECT
	CAST(YearValue + '-' + MonthValue + '-01 00:00:00' AS datetime) AS DateValue
FROM
(
	SELECT DISTINCT
		CAST(YEAR(TransactionDate) AS varchar) AS YearValue,
		CAST(MONTH(TransactionDate) AS varchar) AS MonthValue
	FROM
		tblRegister
	WHERE
		ClientId IN (SELECT ClientId FROM @clientIds) 
		AND NOT TransactionDate IS NULL
) DERIVEDTBL
WHERE --there's a paid fee
	(SELECT COUNT(*) FROM tblRegister WHERE 
		ClientId IN (SELECT ClientId FROM @clientIds) 
		AND tblRegister.IsFullyPaid=1
		AND TransactionDate >= CAST(YearValue + '-' + MonthValue + '-10 00:00:00' AS datetime) 
		AND TransactionDate < DATEADD(MONTH, 1, CAST(YearValue + '-' + MonthValue + '-10 00:00:00' AS datetime))
	) > 0
ORDER BY
	DateValue DESC
GO
