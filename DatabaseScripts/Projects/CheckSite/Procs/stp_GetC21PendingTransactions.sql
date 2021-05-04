IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetC21PendingTransactions')
	BEGIN
		DROP  Procedure  stp_GetC21PendingTransactions
	END

GO

CREATE Procedure stp_GetC21PendingTransactions 
AS
SELECT TransactionId,  FrontImagePath, BackImagePath, DepositId, 
Status, State, ReceivedDate, ProcessedDate, ExceptionCode, Notes
FROM tblC21BatchTransaction
Where Closed = 0

GO
