IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetDailyAttorneyPayouts')
	BEGIN
		DROP  Procedure  stp_GetDailyAttorneyPayouts
	END

GO
CREATE PROCEDURE [dbo].[stp_GetDailyAttorneyPayouts]
	@sDate as DATETIME = NULL
AS
BEGIN

	SET NOCOUNT ON;
-- =============================================
-- Author:		Jim Hope
-- Create date: 07/02/2011
-- Description:	Gathers attorney GCA balance data for the day
-- Modified: 07/27/2011 by Jim Hope
-- =============================================
--Test*****************************************************
--DECLARE @sDate DATETIME
--**********************************************************

--Declare variables**************************************
DECLARE @cName VARCHAR(150)
--DECLARE @cAmount VARCHAR(100)
DECLARE @cAccountNumber VARCHAR(100)
DECLARE @eDate DATETIME
DECLARE @CurrentBalance MONEY
DECLARE @Deposits MONEY
DECLARE @AdjBal MONEY
DECLARE @CompanyID INT
DECLARE @coName VARCHAR(150)
DECLARE @PlannedPayout MONEY
DECLARE @AccountNumber VARCHAR(100)
DECLARE @BankBalance Money

--Declared tables
CREATE TABLE #tbl (
dir VARCHAR(3), 
companyid INT, 
amount MONEY, 
pend BIT
)

--Create temporary tables
CREATE TABLE #tblCurBal (
CompanyID INT,
Attorney VARCHAR(150),
CurrentBalance MONEY
)

CREATE TABLE #tblGCAPayout (
[CompanyID] INT,
[Name] VARCHAR(150),
[Payout] MONEY,
[AccountNumber] VARCHAR(50)
)

CREATE TABLE #tblGCADeposits(
CompanyID INT,
[Disbursment date] VARCHAR(15),
[AttorneyGCA] VARCHAR(150),
[BankBalance] MONEY DEFAULT(0),
[CurrentBalance] MONEY,
[Deposits] MONEY,
[PlannedPayout] MONEY,
[NewBalance] MONEY,
[AdjustedBalance] MONEY
)

CREATE TABLE #tblPayoutByAtty
(
companyID INT,
coName VARCHAR(150),
PlannedPayout MONEY,
AccountNumber VARCHAR(100)
)

CREATE TABLE #tblCombinedDeposits(
CompanyID int,
Deposits money
)

CREATE TABLE #tblBankBalances
(
CompanyID INT,
BAICode varchar(50),
AccountNumber VARCHAR(50),
Amount money
)

--Setup the dates for processing
IF @sDate IS NULL
	BEGIN
		SET @sDate = CAST(CAST(GETDATE() AS VARCHAR(12)) + ' 12:00:01 AM' AS DATETIME)
	END
SET @eDate = @sDate + ' 11:59:59 PM'

--Get the bank balances
INSERT #tblBankBalances
SELECT 
cast(cr.CompanyID as int)
, pd.BAICode
, pd.AccountField
, cast(pd.Amount as money)
FROM [LEXSRVSQLPROD1\LEXSRVSQLPROD].[WA].[dbo].[tblM2M_PREDAYSummary] pd
JOIN [LEXSRVSQLPROD1\LEXSRVSQLPROD].[DMS].[dbo].[tblCommRec] cr ON cr.AccountNumber = pd.AccountField
--FROM [WA].[dbo].[tblM2M_PREDAYSummary] pd
--JOIN [DMS].[dbo].[tblCommRec] cr ON cr.AccountNumber = pd.AccountField
WHERE pd.Created BETWEEN @sDate AND @eDate
AND pd.BAICode IN ('072', '045')

--Get CurrentBalances
-- in to gca
INSERT #tbl (dir,companyid,amount,pend)
SELECT 'in',companyid,SUM(amount),pend
FROM (
      SELECT
            companyid,
            CASE 
                  WHEN flow = 'credit' THEN -amount -- credit shadow store, debit gca
                  WHEN flow = 'debit' THEN amount -- debit shadow store, credit gca
            END [amount],
            CASE WHEN nachafileid = -1 THEN 1 ELSE 0 END [pend]
      FROM tblnacharegister2 
      WHERE [name] LIKE '%General Clearing Account%'
            AND (nachafileid > 0 OR nachafileid = -1)

      UNION ALL

      -- bb&t to checksite sda transfers
      SELECT
            n.companyid,
            n.amount,
            CASE WHEN n.nachafileid = -1 THEN 1 ELSE 0 END [pend]
      FROM tblNachaRegister2 n
      JOIN tblCompany c ON c.CompanyID = n.CompanyID
      JOIN tblRegisterPayment rp ON rp.RegisterPaymentID = n.RegisterPaymentID
      WHERE LEN(n.RoutingNumber) = 9      
            AND flow = 'credit' -- should always be credit
            AND (nachafileid > 0 OR nachafileid = -1)
) d
GROUP BY companyid, pend

-- gca out
INSERT #tbl (dir,companyid,amount,pend)
SELECT 'out', companyid, SUM(amount), CASE WHEN nachafileid = -1 THEN 1 ELSE 0 END [pend]
FROM tblnacharegister2 
WHERE commrecid IS NOT NULL
      AND (nachafileid > 1169 OR nachafileid = -1)
GROUP BY companyid, (CASE WHEN nachafileid = -1 THEN 1 ELSE 0 END)

declare @vtblComms table
(
	CompanyID int,
	TrustID int,
	ID int,
	[Type] varchar(14),
	CommScenID int,
	CommRecID int,
	ParentCommRecID int,
	[Order] int,
	Amount money
)

INSERT INTO
	@vtblComms
SELECT
	CompanyID,
	TrustID,
	ID,
	[Type],
	CommScenID,
	CommRecID,
	ParentCommRecID,
	[Order],
	Amount
FROM
(
	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
		cp.CommPayID as ID,
		'CommPay' as [Type],
		cs.CommScenID,
		cs.CommRecID,
		cs.ParentCommRecID,
		cs.[Order],
		cp.Amount
	FROM
		tblCommPay as cp
		inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
		inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cp.CommBatchID is null

	UNION ALL

	SELECT
		cs.CompanyID,
		case when v.converted is null then c.TrustID
			 when v.converted > rp.paymentdate then v.OrigTrustID
			 else c.TrustID 
		end [TrustID],
		cc.CommChargebackID as ID,
		'CommChargeback' as [Type],
		cs.CommScenID,
		cs.CommRecID,
		cs.ParentCommRecID,
		cs.[Order],
		-cc.Amount
	FROM
		tblCommChargeback as cc
		inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
		inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
		inner join tblClient as c on c.ClientID = r.ClientID
		inner join tblCommStruct as cs on cs.CommStructID = cc.CommStructID
		left join vw_ClientTrustConvDate v on v.clientid = c.clientid
	WHERE
		cc.CommBatchID is null
) as drvComms

INSERT #tbl (dir,companyid,amount,pend)
SELECT 
CASE WHEN v.Amount < 0 THEN 'out' ELSE 'in' END
, v.CompanyID
, v.Amount
, 0
from @vtblcomms v
JOIN tblCommRec cr ON cr.CommRecID = v.CommRecID
WHERE Display LIKE '%General Clearing%'
--group BY cr.display
--HAVING sum(v.Amount) < 0

-- negative means more went out than in
INSERT INTO #tblCurBal
SELECT 
      t.companyid,
	  c.name,
      SUM(CASE WHEN t.dir = 'in' THEN t.amount ELSE 0 END) - SUM(CASE WHEN t.dir = 'out' THEN t.amount ELSE 0 END) [balance]
FROM #tbl t
JOIN tblCompany c ON c.CompanyID = t.companyid
WHERE t.pend = 0
GROUP BY c.Name, t.companyid
ORDER BY c.name

--Load the current balances into the master table #tblGCADeposits
DECLARE c_CurrentBalance CURSOR FOR
SELECT * FROM #tblCurBal

OPEN c_CurrentBalance

FETCH NEXT FROM c_CurrentBalance INTO @companyid, @coName, @CurrentBalance
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #tblGCADeposits(CompanyID, [Disbursment Date], AttorneyGCA, CurrentBalance)
							VALUES(@CompanyID, cast(getdate() AS varchar(12)), @coName, @CurrentBalance)
		FETCH NEXT FROM c_CurrentBalance INTO @companyid, @coName, @CurrentBalance
		END
		
CLOSE c_CurrentBalance
DEALLOCATE c_CurrentBalance

--Get the new Deposits
TRUNCATE TABLE #tbl
INSERT #tbl (dir,companyid,amount,pend)
SELECT 'in',companyid,SUM(amount),pend
FROM (
      SELECT
            companyid,
            CASE 
                  WHEN flow = 'credit' THEN -amount -- credit shadow store, debit gca
                  WHEN flow = 'debit' THEN amount -- debit shadow store, credit gca
            END [amount],
            CASE WHEN nachafileid = -1 THEN 1 ELSE 0 END [pend]
      FROM tblnacharegister2 
      WHERE [name] LIKE '%General Clearing Account%'
            AND nachafileid = -1
            --AND Created BETWEEN '07/27/2011 12:00:01 AM' AND '07/27/2011 11:59:59 PM' --Testing only
      UNION ALL

      -- bb&t to checksite sda transfers
      SELECT
            n.companyid,
            n.amount,
            CASE WHEN n.nachafileid = -1 THEN 1 ELSE 0 END [pend]
      FROM tblNachaRegister2 n
      JOIN tblCompany c ON c.CompanyID = n.CompanyID
      JOIN tblRegisterPayment rp ON rp.RegisterPaymentID = n.RegisterPaymentID
      WHERE LEN(n.RoutingNumber) = 9      
            AND flow = 'credit' -- should always be credit
            AND nachafileid = -1
            --AND n.Created BETWEEN '07/27/2011 12:00:01 AM' AND '07/27/2011 11:59:59 PM' --Testing only
            
     UNION ALL
     
     --Palmer and Seideman
     SELECT
            n.companyid,
            n.amount,
            CASE WHEN n.nachafileid IS NULL THEN 1 ELSE 0 END [pend]
      FROM tblNachaRegister n
     JOIN tblCompany c ON c.CompanyID = n.CompanyID
      WHERE n.Amount > 0 
            AND nachafileid IS NULL
            AND IsPersonal = 0
            AND [n].[Name] LIKE '%general%'
) d
GROUP BY companyid, pend

DECLARE c_Deposits CURSOR FOR
SELECT companyid, sum(Amount) FROM #tbl group by companyid

OPEN c_Deposits

FETCH NEXT FROM c_Deposits INTO @companyid, @Deposits
	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE #tblGCADeposits SET Deposits = @Deposits
							WHERE CompanyID=@CompanyID
		FETCH NEXT FROM c_Deposits INTO @companyid, @Deposits
		END
		
CLOSE c_Deposits
DEALLOCATE c_Deposits

--Payouts
TRUNCATE TABLE #tbl
INSERT #tbl (dir,companyid,amount,pend)
SELECT 'out', companyid, SUM(amount), CASE WHEN nachafileid = -1 THEN 1 ELSE 0 END [pend]
FROM tblnacharegister2 
WHERE commrecid IS NOT NULL
      --AND nachafileid > 1169 
      AND nachafileid = -1
      --AND Created BETWEEN '07/28/2011 12:00:01 AM' AND '07/28/2011 11:59:59 PM' --Testing only
GROUP BY companyid, (CASE WHEN nachafileid = -1 THEN 1 ELSE 0 END)

INSERT #tbl(dir,companyid,amount,pend)
SELECT 'out', companyid, SUM(amount) * -1, CASE WHEN nachafileid IS NULL THEN 1 ELSE 0 END [pend]
FROM tblNachaRegister
WHERE IsPersonal = 0
AND Amount < 0
AND NachaFileId IS NULL
AND  [Name] like '%Clearing Account%'
GROUP BY CompanyID, (CASE WHEN NachaFileId is NULL THEN 1 ELSE 0 END)

DECLARE c_Payouts CURSOR FOR
SELECT companyid, sum(Amount) FROM #tbl group by companyid

OPEN c_Payouts

FETCH NEXT FROM c_Payouts INTO @companyid, @PlannedPayout
	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE #tblGCADeposits SET PlannedPayout = @PlannedPayout
							WHERE CompanyID=@CompanyID
		FETCH NEXT FROM c_Payouts INTO @companyid, @PlannedPayout
		END
		
CLOSE c_Payouts
DEALLOCATE c_Payouts

--New Balance
DECLARE c_NewBalance CURSOR FOR
SELECT companyid
, CurrentBalance
, Deposits
, PlannedPayout
FROM #tblGCADeposits 

OPEN c_NewBalance

FETCH NEXT FROM c_NewBalance INTO @companyid, @CurrentBalance, @Deposits, @PlannedPayout
	WHILE @@FETCH_STATUS = 0
		BEGIN
		--print @PlannedPayout
			IF @PlannedPayout IS NOT NULL AND @Deposits IS NOT NULL
				BEGIN
					UPDATE #tblGCADeposits SET NewBalance = @CurrentBalance + @Deposits - @PlannedPayout WHERE CompanyID=@CompanyID		
				END
			IF @PlannedPayout IS NULL AND @Deposits IS NOT NULL
				BEGIN
					UPDATE #tblGCADeposits SET NewBalance = @CurrentBalance + @Deposits, PlannedPayout = 0 WHERE CompanyID=@CompanyID		
				END
		IF @PlannedPayout IS NOT NULL AND @Deposits IS NULL
			BEGIN
				UPDATE #tblGCADeposits SET NewBalance = @CurrentBalance + @PlannedPayout, Deposits = 0 WHERE CompanyID=@CompanyID
			END
		IF @PlannedPayout IS NULL AND @Deposits IS NULL
			BEGIN
				UPDATE #tblGCADeposits SET NewBalance = @CurrentBalance, PlannedPayout = 0, Deposits = 0 WHERE CompanyID=@CompanyID 
			END
		FETCH NEXT FROM c_NewBalance INTO @companyid, @CurrentBalance, @Deposits, @PlannedPayout
		END
		
		CLOSE c_NewBalance
DEALLOCATE c_NewBalance
		
--Update the bank balances for each attorney
DECLARE c_BankBalances CURSOR FOR
SELECT companyid, sum(Amount) FROM #tblBankBalances group by companyid

OPEN c_BankBalances

FETCH NEXT FROM c_BankBalances INTO @companyid, @BankBalance
	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE #tblGCADeposits SET BankBalance = @BankBalance
							WHERE CompanyID=@CompanyID
		FETCH NEXT FROM c_BankBalances INTO @companyid, @BankBalance
		END
		
CLOSE c_BankBalances
DEALLOCATE c_BankBalances
		
SELECT * FROM #tblGCADeposits

DROP TABLE #tblCurBal
DROP TABLE #tblBankBalances
DROP TABLE #tblCombinedDeposits
DROP TABLE #tblGCADeposits
DROP TABLE #tblGCAPayout
DROP TABLE #tblPayoutByAtty
DROP TABLE #tbl
END

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

