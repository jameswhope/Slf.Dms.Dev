IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertProcessingReportDetail')
	BEGIN
		DROP  Procedure  stp_InsertProcessingReportDetail
	END

GO

CREATE Procedure stp_InsertProcessingReportDetail
@ReportId int,
@StateId int,
@TransactionId varchar(50),
@TransactionType int,
@Notes varchar(max)
AS
BEGIN
	Insert into tblProcessingReportDetail(ReportId, StateId, TransactionId, TransactionType, Notes)
	Values (@ReportId, @StateId, @TransactionId, @TransactionType, @Notes)
	
	Select scope_identity()

END

GO
