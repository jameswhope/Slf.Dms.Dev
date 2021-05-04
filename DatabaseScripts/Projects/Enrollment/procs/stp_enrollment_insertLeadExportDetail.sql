IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_insertLeadExportDetail')
	BEGIN
		DROP  Procedure  stp_enrollment_insertLeadExportDetail
	END

GO

CREATE Procedure stp_enrollment_insertLeadExportDetail
@ExportJobId int,		   
@LeadApplicantId int
AS
BEGIN
	Insert Into tblLeadExportDetail(ExportJobId, LeadApplicantId)
	Values (@ExportJobId, @LeadApplicantId)
	
	SELECT SCOPE_IDENTITY()
END

GO

