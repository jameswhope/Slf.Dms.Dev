IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetDailyWithholding')
	BEGIN
		DROP  Procedure  stp_GetDailyWithholding
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 07/15/2011
-- Description:	Individula payout witholding amounts and balances
-- =============================================
CREATE PROCEDURE stp_GetDailyWithholding 
	@sDate datetime = null, 
	@Pct real = 0.00,
	@AccountNumber varchar(50)
AS
BEGIN

	SET NOCOUNT ON;

----Test data**********************
--DECLARE @Pct REAL
--DECLARE @AccountNumber VARCHAR(50)
--DECLARE @sDate DATETIME
--SET @AccountNumber = '003108720'
--SET @Pct = .10
----*******************************

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
, 0.00
, 0.00
FROM tblnacharegister
WHERE IsPersONal = 0
AND Amount > 0
AND Created > '07/14/2011 12:00:01 AM'
AND [Name] not LIKE '%operating%'
AND [Name] NOT LIKE '%clearing%'
AND [Name] NOT like '%disbursement%'
AND [Name] NOT like '%trust%'
AND AccountNumber = @AccountNumber
--AND NachaFileId = -1

UNION ALL

SELECT 
2
, NachaRegisterID
, [Name]
, RoutingNumber
, AccountNumber
, Amount
, 0.00
, 0.00
FROM tblnacharegister2
WHERE IsPersONal = 0
AND Flow = 'debit'
AND Created > '07/14/2011 12:00:01 AM'
AND [Name] not LIKE '%operating%'
AND [Name] NOT LIKE '%clearing%'
AND [Name] NOT like '%disbursement%'
AND AccountNumber = @AccountNumber
--AND NachaFileId = -1

DECLARE c_withhold CURSOR FOR
SELECT NachaRegister, NachaRegisterID, [Name], Amount
FROM #tblpayout 
WHERE AccountNumber = @AccountNumber
OPEN c_withhold
	
FETCH NEXT FROM c_withhold INTO @NachaRegister, @NachaRegisterID, @Name, @Amount
WHILE @@FETCH_STATUS = 0
BEGIN
		SET @Withhold = CAST((@Amount * @pct) AS VARCHAR(12))
		SET @Balance = @Amount - @Withhold
		UPDATE #tblpayout SET withhold = @Withhold, balance = @balance 
		WHERE NachaRegister = @nacharegister 
				AND nacharegisterid = @nacharegisterid

	FETCH NEXT FROM c_withhold INTO @NachaRegister, @NachaRegisterID, @Name, @Amount
END

CLOSE c_withhold
DEALLOCATE c_withhold

SELECT * FROM #tblPayout 
WHERE AccountNumber = @accountnumber

DROP TABLE #tblPayout
END
GO

/*
GRANT EXEC ON stp_GetDailyWithholding TO PUBLIC

GO
*/

