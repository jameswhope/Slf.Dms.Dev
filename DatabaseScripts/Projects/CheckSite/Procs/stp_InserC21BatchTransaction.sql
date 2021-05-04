IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertC21BatchTransaction')
	BEGIN
		DROP  Procedure  stp_InsertC21BatchTransaction
	END

GO

CREATE Procedure stp_InsertC21BatchTransaction
@TransactionId varchar(50),
@BatchId varchar(50)
AS
INSERT INTO tblC21BatchTransaction (TransactionId, BatchId, Created)
VALUES (@TransactionId, @BatchId, GetDate())
GO

