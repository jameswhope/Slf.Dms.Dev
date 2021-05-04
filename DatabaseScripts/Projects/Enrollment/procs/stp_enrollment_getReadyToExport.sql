IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getReadyToExport')
	BEGIN
		DROP  Procedure  stp_enrollment_getReadyToExport
	END
GO

create procedure stp_enrollment_getReadyToExport
(
	@UserId int = 0,
	@Manager bit = 0
)
as
BEGIN
	/*
		ExportStatus 3: Locked during Export, 1: Exported, 0: Not Exported, 2: Error
	*/
	IF @Manager = 1
		BEGIN
			SELECT 
				  la.LeadApplicantID
				, la.LeadTransferInDate
				, case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName]
				, case when rtrim(ltrim(la.HomePhone)) = '(   )    -' then '' else la.HomePhone end [HomePhone]
				, lc.TotalDebt
				, so.Name
				, st.Description
				, u.FirstName + ' ' + u.LastName AS AssignedTo
				, '' [LastContacted] -- date avail?
				, isnull(la.EnrollmentPage, 'newenrollment.aspx') as EnrollmentPage	   
			FROM tblLeadApplicant AS la 
				JOIN tblUser AS u ON la.RepID = u.UserID 
				LEFT JOIN tblLeadCalculator lc on lc.LeadApplicantID = la.LeadApplicantID
				LEFT OUTER JOIN tblLeadStatus AS st ON la.StatusID = st.StatusID 
				LEFT OUTER JOIN tblLeadSources AS so ON la.LeadSourceID = so.LeadSourceID
				LEFT OUTER JOIN tblLeadExportDetail ed ON la.LeadApplicantId = ed.LeadApplicantId AND ed.ExportStatus in (1,3)
			WHERE     
				la.StatusID IN (7)
				AND ed.LeadApplicantId Is NULL
			ORDER BY
				la.LeadTransferInDate
		END
	ELSE 
		BEGIN
			SELECT 
				  la.createdbyid
				, la.repid
				, la.LeadApplicantID
				, la.LeadTransferInDate
				, case when len(rtrim(ltrim(la.FullName))) > 0 then la.FullName else '[No Name]' end [FullName]
				, case when rtrim(ltrim(la.HomePhone)) = '(   )    -' then '' else la.HomePhone end [HomePhone]
				, lc.TotalDebt
				, so.Name
				, st.Description
				, u.FirstName + ' ' + u.LastName AS AssignedTo
				, '' [LastContacted] -- date avail?
				, isnull(la.EnrollmentPage, 'newenrollment.aspx') as EnrollmentPage	
			FROM tblLeadApplicant AS la 
				JOIN tblUser AS u ON la.RepID = u.UserID 
				LEFT JOIN tblLeadCalculator lc on lc.LeadApplicantID = la.LeadApplicantID
				LEFT OUTER JOIN tblLeadStatus AS st ON la.StatusID = st.StatusID 
				LEFT OUTER JOIN tblLeadSources AS so ON la.LeadSourceID = so.LeadSourceID
				LEFT OUTER JOIN tblLeadExportDetail ed ON la.LeadApplicantId = ed.LeadApplicantId AND ed.ExportStatus in (1,3)
			WHERE     
				la.StatusID IN (7) AND la.RepID = @UserID
				AND ed.LeadApplicantId IS NULL
			ORDER BY
				la.LeadTransferInDate
		END
END
GO