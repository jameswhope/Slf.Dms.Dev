IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetStmtResults')
	BEGIN
		DROP  Procedure  stp_GetStmtResults
	END

GO

CREATE Procedure [dbo].[stp_GetStmtResults]
(
		@AccountNumber INT,
		@StmtPeriod VARCHAR(50),
		@StartDate VARCHAR(50),
		@EndDate VARCHAR(50)
	)
AS
SELECT 
	[ClientID]
	,[AccountNumber]
	,[RegisterFirst]
	,[registerID]
	,[TransactionDate]
	,[CheckNo]
	,[EntryTypeID]
	,[EntryTypeName]
	,[OrigionalAmt]
	,[Amount]
	,[SDABalance]
	,[PFOBalance]
	,[description] = case when [description] is null then [EntryTypeName] else [EntryTypeName] + ' ' + [description] end
	,[AccountID]
	,[CreditorName]
	,[CreditorAcctNo]
	,[CurrentAmount]
	,[AdjustRegisterID]
	,[AdjTransactionDate]
	,[AdjRegAmount]
	,[AdjRegOrigAmount]
	,[AdjRegEntryTypeID]
	,[AdjRegAcctID]
	,[AdjRegAcctCreditorName]
	,[AdjRegAcctAcctNo]
	,[ACHMonth]
	,[ACHYear]
	,[FeeMonth]
	,[FeeYear]
	,[BounceOrVoid]
	,[NumNotes]
	,[NumPhoneCalls]
	,[StmtPeriod] 
FROM [ClientStatements]..[tblStatementResults] 
WHERE [ClientStatements]..[tblStatementResults].[StmtPeriod] = @StmtPeriod 
AND [ClientStatements]..[tblStatementResults].[AccountNumber] = @AccountNumber
AND [ClientStatements]..[tblStatementResults].[TransactionDate] BETWEEN @StartDate AND @EndDate


