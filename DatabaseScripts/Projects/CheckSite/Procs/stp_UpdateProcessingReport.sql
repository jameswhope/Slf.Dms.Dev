IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateProcessingReport')
	BEGIN
		DROP  Procedure  stp_UpdateProcessingReport 
	END

GO

CREATE Procedure stp_UpdateProcessingReport 
@ReportId int,
@Notes varchar(max)
AS
Update tblProcessingReport Set
Notes=@Notes
Where ReportId = @ReportId

GO

