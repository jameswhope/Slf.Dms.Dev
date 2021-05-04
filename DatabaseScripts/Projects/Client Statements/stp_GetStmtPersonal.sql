IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetStmtPersonal')
	BEGIN
		DROP  Procedure  stp_GetStmtPersonal
	END

GO

CREATE Procedure stp_GetStmtPersonal
	(
		@AccountNumber INT,
		@StmtPeriod VARCHAR(50)
	)
AS
SELECT * FROM [ClientStatements]..[tblStatementPersonal] 
WHERE [ClientStatements]..[tblStatementPersonal].[StmtPeriod] = @StmtPeriod 
AND [ClientStatements]..[tblStatementPersonal].[AccountNumber] = @AccountNumber

GO


