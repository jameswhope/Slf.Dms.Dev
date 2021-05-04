IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertC21Batch')
	BEGIN
		DROP  Procedure  stp_InsertC21Batch
	END

GO

CREATE Procedure stp_InsertC21Batch
@BatchId varchar(50),
@RequestBeginDate Datetime,
@RequestEndDate Datetime
AS
INSERT INTO tblC21Batch (BatchId, Created, RequestBeginDate, RequestEndDate)
VALUES (@BatchId, GetDate(), @RequestBeginDate, @RequestEndDate)
GO


