IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetProcessingReport')
	BEGIN
		DROP  Procedure  stp_GetProcessingReport
	END

GO

CREATE Procedure stp_GetProcessingReport
@ReportId int
AS
Select ReportId, ReportDate, SessionID, Notes From tblProcessingReport
Where ReportId=@ReportId

GO

