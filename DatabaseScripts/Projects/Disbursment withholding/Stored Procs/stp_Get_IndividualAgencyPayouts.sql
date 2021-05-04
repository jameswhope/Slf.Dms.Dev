IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Get_IndividualAgencyPayouts')
	BEGIN
		DROP  Procedure  stp_Get_IndividualAgencyPayouts
	END

GO

CREATE Procedure [dbo].[stp_GetIndividualAgencyPayouts]
	(
		@Pct real,
		@AccountNumber varchar(50),
		@sDate datetime = null
	)
AS
--test************************************
--DECLARE @Pct REAL
--DECLARE @AccountNumber VARCHAR(50)
--DECLARE @sDate DATETIME
--SET @AccountNumber = '501007287532'
--SET @Pct = .10
--****************************************

DECLARE @NachaRegister INT
DECLARE @NachaRegisterID INT
DECLARE @Name VARCHAR(150)
DECLARE @RoutingNumber VARCHAR(50)
DECLARE @Amount NUMERIC(18,2)
DECLARE @Withhold REAL
DECLARE @Balance REAL
DECLARE @eDate DATETIME

IF @sDate = NULL
	BEGIN
		SET @sDate = cast(cast(GETDATE() AS VARCHAR(12)) + ' 12:00:01 AM' as datetime)
	END
ELSE
	BEGIN
		SET @eDate = @sDate + ' 11:59:59 PM'
	END

CREATE TABLE #tblPayout
(
NachaRegister INT,
NachaRegisterID INT,
[Name] VARCHAR(150),
RoutingNumber VARCHAR(50),
AccountNumber VARCHAR(50),
Amount NUMERIC(18,2),
WithHold NUMERIC(18, 2),
Balance NUMERIC(18,2)
)

INSERT INTO #tblPayout

SELECT
1
, NachaRegisterID
, [Name]
, RoutingNumber
, AccountNumber
, Amount
, @pct * Amount
, Amount - (@pct * Amount)
FROM tblnacharegister
WHERE IsPersONal = 0
AND Amount > 0
AND Created BETWEEN @sDate AND @eDate
AND [Name] not LIKE '%operating%'
AND [Name] NOT LIKE '%clearing%'
AND [Name] NOT like '%disbursement%'
AND [Name] NOT like '%trust%'
AND AccountNumber = @AccountNumber
--AND NachaFileId is null

UNION ALL

SELECT 
2
, NachaRegisterID
, [Name]
, RoutingNumber
, AccountNumber
, Amount
, @pct * Amount
, Amount - (@pct * Amount)
FROM tblnacharegister2
WHERE IsPersONal = 0
AND Flow = 'debit'
AND Created BETWEEN @sDate AND @eDate
AND [Name] not LIKE '%operating%'
AND [Name] NOT LIKE '%clearing%'
AND [Name] NOT like '%disbursement%'
AND AccountNumber = @AccountNumber
AND NachaFileId = -1

SELECT * FROM #tblPayout 
WHERE AccountNumber = @accountnumber

DROP TABLE #tblPayout

GO

/*
GRANT EXEC ON stp_Get_IndividualAgencyPayouts TO PUBLIC

GO
*/

