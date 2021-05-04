IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getNotes')
	BEGIN
		DROP  Procedure  stp_enrollment_getNotes
	END

GO

create procedure stp_enrollment_getNotes
(
	@applicantID int
)
as
BEGIN
	IF @applicantID <> 0
		BEGIN
			SELECT ln.LeadApplicantID,ln.LeadNoteID,ln.NoteTypeID, ln.NoteType, ln.Created, ln.Value
			FROM tblLeadNotes AS ln
			Left join tblRedoLeads r on r.leadapplicantid = ln.LeadApplicantId
			WHERE (ln.LeadApplicantID = @applicantID)
			and (r.leadapplicantid is null or ln.created > r.created)
			ORDER BY ln.Modified desc
		END
END
