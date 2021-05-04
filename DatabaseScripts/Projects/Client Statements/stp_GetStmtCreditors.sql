IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetStmtCreditors')
	BEGIN
		DROP  Procedure  stp_GetStmtCreditors
	END

GO

CREATE Procedure stp_GetStmtCreditors
(
		@AccountNumber INT,
		@StmtPeriod VARCHAR(50)
	)
AS
SELECT * FROM [ClientStatements]..[tblStatementCreditor] 
WHERE [ClientStatements]..[tblStatementCreditor].[StmtPeriod] = @StmtPeriod 
AND [ClientStatements]..[tblStatementCreditor].[Acct_No] = @AccountNumber

GO




