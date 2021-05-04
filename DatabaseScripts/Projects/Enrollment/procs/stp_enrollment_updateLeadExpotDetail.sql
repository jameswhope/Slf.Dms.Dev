IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_updateLeadExportDetail')
	BEGIN
		DROP  Procedure  stp_enrollment_updateLeadExportDetail
	END

GO

CREATE Procedure stp_enrollment_updateLeadExportDetail
@ExportJobId int,		   
@LeadApplicantId int,
@ExportStatus int = null,
@Note varchar(max) = null
AS
BEGIN
	Update tblLeadExportDetail Set
	ExportStatus = isnull(@ExportStatus, ExportStatus),
	Note = isnull(@Note, Note) 
	Where ExportJobId = @ExportJobId
	And LeadApplicantId = @LeadApplicantId
END

GO
