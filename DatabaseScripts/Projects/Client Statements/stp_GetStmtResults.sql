IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetStmtResults')
	BEGIN
		DROP  Procedure  stp_GetStmtResults
	END

GO

CREATE Procedure stp_GetStmtResults
(
		@AccountNumber INT,
		@StmtPeriod VARCHAR(50),
		@StartDate VARCHAR(50),
		@EndDate VARCHAR(50)
	)
AS
SELECT * FROM [ClientStatements]..[tblStatementResults] 
WHERE [ClientStatements]..[tblStatementResults].[StmtPeriod] = @StmtPeriod 
AND [ClientStatements]..[tblStatementResults].[AccountNumber] = @AccountNumber
AND [ClientStatements]..[tblStatementResults].[TransactionDate] BETWEEN @StartDate AND @EndDate

GO

