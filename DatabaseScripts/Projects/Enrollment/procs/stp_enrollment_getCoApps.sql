IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getCoApps')
	BEGIN
		DROP  Procedure  stp_enrollment_getCoApps
	END

GO

create procedure stp_enrollment_getCoApps
(
	@applicantid int
)
as
	BEGIN
		IF @applicantID <> 0
		BEGIN
			select 
				[full name]
				, AuthorizationPower
				, LeadCoApplicantID
				, ssn
			from 
				tblleadcoapplicant
			where 
				leadapplicantid = @applicantid
		END
	END
