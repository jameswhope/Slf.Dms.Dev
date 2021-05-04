IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getExportDetails')
	BEGIN
		DROP  Procedure stp_enrollment_getExportDetails
	END

GO

CREATE Procedure stp_enrollment_getExportDetails
@ExportJobId int
AS
SELECT 
	   la.LeadApplicantID as [LeadApplicantId],
	   Case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName],
	   Case ed.ExportStatus
	   When 0 Then 'Not Exported'
	   When 1 Then 'Exported OK'
	   When 2 Then 'Failed'
	   Else 'Exporting'
	   END AS [Status],
	   ed.Note,
	   isnull(la.EnrollmentPage, 'newenrollment.aspx') as EnrollmentPage	   
FROM tblLeadExportDetail ed
inner join tblLeadApplicant la on ed.LeadApplicantId = la.LeadApplicantId
Where ed.ExportJobID = @ExportJobId

GO
