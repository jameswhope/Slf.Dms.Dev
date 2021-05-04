IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getAllExportDetails')
	BEGIN
		DROP  Procedure stp_enrollment_getAllExportDetails
	END

GO

CREATE Procedure stp_enrollment_getAllExportDetails
AS
SELECT 
	   ed.LeadExportId,
	   ed.ExportJobId,
	   la.LeadApplicantID as [LeadApplicantId],
	   Case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName],
	   Case ed.ExportStatus
	   When 0 Then 'Not Exported'
	   When 1 Then 'Exported OK'
	   When 2 Then 'Failed'
	   Else 'Exporting'
	   END AS [Status],
	   ed.Note	   
FROM tblLeadExportDetail ed
inner join tblLeadApplicant la on ed.LeadApplicantId = la.LeadApplicantId
