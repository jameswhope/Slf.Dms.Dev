/****** Object:  StoredProcedure [dbo].[stp_AgencyGetCommissionDataSummary]    Script Date: 11/19/2007 15:26:51 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetCommissionDataSummary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetCommissionDataSummary]
(
	@agencyId int,
	@year int
)

AS

SET NOCOUNT ON

DECLARE @startDate datetime
DECLARE @endDate datetime

SET @startDate = CAST(CAST(@year AS varchar) + '-01-01' AS datetime);
SET @endDate = CAST(CAST(@year AS varchar) + '-12-31' AS datetime);

DECLARE @clientInfo TABLE
(
	ClientId int PRIMARY KEY
)

-- Get all transactions from this month
SELECT
	EntryTypeId,
	MONTH(TransactionDate) as [Month],
	SUM(ABS(Amount)) as AmountSum
FROM
	tblRegister
WHERE
	--only clients for this agency
	ClientId IN (SELECT ClientId FROM tblClient WHERE AgencyId=@agencyId) AND
	TransactionDate >= @startDate AND
	TransactionDate < @endDate
GROUP BY
	EntryTypeId,
	MONTH(TransactionDate)
ORDER BY 
	[Month],
	EntryTypeId
GO
