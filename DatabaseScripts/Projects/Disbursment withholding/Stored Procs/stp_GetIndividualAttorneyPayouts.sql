IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetIndividualAttorneyPayouts')
	BEGIN
		DROP  Procedure  stp_GetIndividualAttorneyPayouts
	END

GO

CREATE Procedure [dbo].[stp_GetIndividualAttorneyPayouts]
	(
		@Pct real,
		@AccountNumber varchar(50),
		@sDate datetime = null,
		@eDate datetime = null
	)
AS
--test************************************
--DECLARE @Pct REAL
--DECLARE @AccountNumber VARCHAR(50)
--DECLARE @sDate DATETIME
--DECLARE @eDate DATETIME
--SET @AccountNumber = '0005101132147'
--SET @Pct = .10
--SET @sDate = '09/26/2011'
--SET @eDate = NULL
--****************************************

DECLARE @NachaRegister INT
DECLARE @NachaRegisterID INT
DECLARE @Name VARCHAR(150)
DECLARE @RoutingNumber VARCHAR(50)
DECLARE @Amount Money
DECLARE @Withhold Money
DECLARE @Balance Money

IF @sDate IS NULL
	BEGIN
		SET @sDate = cast(cast(GETDATE() AS VARCHAR(12)) + ' 12:01AM' as datetime)
	END
ELSE
	BEGIN
		SET @sDate = cast(cast(@sDate AS varchar(12)) + ' 12:01AM' AS datetime)
	END
IF @eDate IS NULL
	BEGIN
		SET @eDate = cast(cast(getdate() AS varchar(12)) + ' 11:59PM' as datetime)
	END
ELSE
	BEGIN
		SET @eDate = cast(cast(@eDate AS varchar(12)) + ' 11:59PM' as datetime)
	END

CREATE TABLE #tblPayout
(
NachaRegister INT,
NachaRegisterID INT,
[Name] VARCHAR(150),
RoutingNumber VARCHAR(50),
AccountNumber VARCHAR(50),
Amount money,
WithHold money,
Balance money
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
WHERE IsPersonal = 0
AND Amount > 0
AND Created BETWEEN @sDate AND @eDate
AND [Name] LIKE '%operating%'
AND [Name] NOT LIKE '%clearing%'
AND [Name] NOT LIKE '%disbursement%'
AND [Name] NOT LIKE '%trust%'
AND AccountNumber = @AccountNumber
AND NachaFileId is null

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
WHERE IsPersonal = 0
AND Flow = 'debit'
AND Created BETWEEN @sDate AND @eDate
AND [Name] LIKE '%operating%'
AND [Name] NOT LIKE '%clearing%'
AND [Name] NOT LIKE '%disbursement%'
AND AccountNumber = @AccountNumber
AND NachaFileId = -1

SELECT * FROM #tblPayout 

DROP TABLE #tblPayout 
GO

/*
GRANT EXEC ON stp_GetIndividualAttorneyPayouts TO PUBLIC

GO
*/

