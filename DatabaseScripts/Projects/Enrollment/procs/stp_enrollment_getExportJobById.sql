IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getExportJobById')
	BEGIN
		DROP  Procedure  stp_enrollment_getExportJobById
	END

GO

CREATE Procedure stp_enrollment_getExportJobById
@ExportJobId int
AS
Select le.ExportJobId, le.ExportDate, 
isnull(u.firstName,'') + ' ' + isnull(u.LastName,'') as [ExecutedBy], 
CASE le.Status 
	WHEN 0 THEN 'Exporting'
	WHEN 1 THEN 'Completed'
	WHEN 2 THEN 'Failed'
	ELSE 'Unknown'
END AS [Status],
le.Notes,
(Select Count(LeadExportId) From tblLeadExportDetail Where ExportJobId = le.ExportJobId) as [ApplicantCount],
(Select Count(LeadExportId) From tblLeadExportDetail Where ExportJobId = le.ExportJobId and exportstatus = 1) as [Succeeded],
(Select Count(LeadExportId) From tblLeadExportDetail Where ExportJobId = le.ExportJobId and exportstatus = 2) as [Failed], 
(Select Count(LeadExportId) From tblLeadExportDetail Where ExportJobId = le.ExportJobId and exportstatus not in (1,2)) as [LeftPending]  
From tblLeadExportJob le
left join tbluser u on le.executedBy = u.userId 
Where le.ExportJobId = @ExportJobId

GO
