IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getEmails')
	BEGIN
		DROP  Procedure  stp_enrollment_getEmails
	END

GO

CREATE Procedure stp_enrollment_getEmails
@LeadApplicantID int
AS
select e.* from tblleademails e
Left join tblRedoLeads r on r.leadapplicantid = e.LeadApplicantId
where e.leadapplicantid = @LeadApplicantID 
and (r.leadapplicantid is null or e.datesent > r.created)
order by e.datesent

GO



