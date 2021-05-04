IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ClientStatementArchiver')
	BEGIN
		DROP  Procedure  stp_ClientStatementArchiver
	END

GO

/* 
Author:			Jim Hope
CREATE date:	12/27/2010
MODIFIED date:	01/04/2011 added archiving to the process

Description:	Stored Proc to move statement data to 12 
month tables and then to archive last years matching run.
*/

CREATE PROCEDURE [dbo].[stp_ClientStatementArchiver] 
(
	@ThisDate DATETIME = NULL
)
AS
	BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--Get the period to remove based on todays date

--Testing data
--	DECLARE @ThisDate DATETIME
--	SET @ThisDate = NULL


DECLARE @StmtPeriodNow VARCHAR(50)
DECLARE @StmtPeriodThen VARCHAR(50)

IF @ThisDate IS NULL
	BEGIN
		SET @ThisDate = GETDATE()
	END

IF DATEPART(DAY, @ThisDate) <= 15
	BEGIN
		SET @StmtPeriodNow = LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) + '1_' 
		+ LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) + '15_' 
		+ CONVERT(VARCHAR(4), DATEPART(YEAR, @ThisDate),0)
		SET @StmtPeriodThen = LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) + '1_' 
		+ LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) + '15_' 
		+ CONVERT(VARCHAR(4), DATEPART(YEAR, DATEADD(YEAR, -1, @ThisDate)),0)
	END

IF DATEPART(DAY, @ThisDate) >= 16 
	BEGIN
		SET @StmtPeriodNow = LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) + '16_' 
		+ LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) 
		+ CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH , 0,@ThisDate)+1 , 0))) AS VARCHAR(10)) 
		+ ''_'' + CONVERT(VARCHAR(4), DATEPART(YEAR, @ThisDate),0)
		SET @StmtPeriodThen = LEFT(CONVERT(VARCHAR(10), @ThisDate),3) + '16_'
		+ LEFT(CONVERT(VARCHAR(10), @ThisDate, 0),3) 
		+ CAST(DATEPART(DAY, DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH , 0,@ThisDate)+1 , 0))) AS VARCHAR(10)) 
		+ ''_'' + CONVERT(VARCHAR(4),DATEPART(YEAR, DATEADD(YEAR, -1, @ThisDate)),0)
	END

/*Copy the data from the statement tables in DMS to the Statement tables in ClientStatements*/

--Personal
IF NOT EXISTS(SELECT TOP 1 * FROM [ClientStatements]..[tblStatementPersonal] WHERE StmtPeriod = @StmtPeriodNow)
	BEGIN
		INSERT INTO [ClientStatements]..[tblStatementPersonal]
		SELECT * 
		FROM DMS..tblStatementPersonal
		WHERE StmtPeriod = @StmtPeriodNow
	END

--Creditors
IF NOT EXISTS(SELECT TOP 1 * FROM [ClientStatements]..[tblStatementCreditor] WHERE StmtPeriod = @StmtPeriodNow)
	BEGIN
		INSERT INTO [ClientStatements]..[tblStatementCreditor]
		SELECT * 
		FROM DMS..tblStatementCreditor
		WHERE StmtPeriod = @StmtPeriodNow
	END

--Transactions
IF NOT EXISTS(SELECT TOP 1 * FROM [ClientStatements]..[tblStatementResults] WHERE StmtPeriod = @StmtPeriodNow)
	BEGIN  
		INSERT INTO [ClientStatements]..[tblStatementResults]
		SELECT * 
		FROM DMS..tblStatementResults
		WHERE StmtPeriod = @StmtPeriodNow
	END

/*Copy the data from the current DB to the archive DB*/

--Archive Personal
IF NOT EXISTS(SELECT TOP 1 * FROM [ClientStatementArchive]..[tblStatementPersonal] WHERE StmtPeriod = @StmtPeriodThen)
	BEGIN
		INSERT INTO [ClientStatementArchive]..[tblStatementPersonal]
		SELECT * 
		FROM [ClientStatements]..[tblStatementPersonal]
		WHERE [ClientStatements]..[tblStatementPersonal].[StmtPeriod] = @StmtPeriodThen
	END

--Archive Creditors
IF NOT EXISTS(SELECT TOP 1 * FROM [ClientStatementArchive]..[tblStatementCreditor] WHERE StmtPeriod = @StmtPeriodThen)
	BEGIN
		INSERT INTO [ClientStatementArchive]..[tblStatementCreditor]
		SELECT * 
		FROM [ClientStatements]..[tblStatementCreditor]
		WHERE [ClientStatements]..[tblStatementCreditor].[StmtPeriod] = @StmtPeriodThen
	END

--Archive Transactions
IF NOT EXISTS(SELECT TOP 1 * FROM [ClientStatementArchive]..[tblStatementResults] WHERE StmtPeriod = @StmtPeriodThen)
	BEGIN  
		INSERT INTO [ClientStatementArchive]..[tblStatementResults]
		SELECT * 
		FROM [ClientStatements]..[tblStatementResults]
		WHERE [ClientStatements]..[tblStatementResults].[StmtPeriod] = @StmtPeriodThen
	END

/*Now remove the last year''''s data from the ClientStatements tables*/

--Delete Personal
DELETE FROM [ClientStatements]..[tblStatementPersonal] WHERE StmtPeriod = @StmtPeriodThen
--Delete Creditors
DELETE FROM [ClientStatements]..[tblStatementCreditor] WHERE StmtPeriod = @StmtPeriodThen
--Delete Transactions
DELETE FROM [ClientStatements]..[tblStatementResults] WHERE StmtPeriod = @StmtPeriodThen

/*No need to remove the data from the DMS tables, as each months data is truncated before 
inserting the new statement data.*/
END