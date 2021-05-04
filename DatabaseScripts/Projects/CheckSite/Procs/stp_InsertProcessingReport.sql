IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertProcessingReport')
	BEGIN
		DROP  Procedure  stp_InsertProcessingReport
	END

GO

CREATE Procedure stp_InsertProcessingReport
@ReportDate datetime,
@SessionId varchar(50),
@Notes varchar(max),
@ReportType varchar(10)
AS
BEGIN
	Insert into tblProcessingReport(ReportDate, SessionId, Notes, ReportType)
	Values (@ReportDate, @SessionId, @Notes, @ReportType)
	
	Select scope_identity()
END

GO


