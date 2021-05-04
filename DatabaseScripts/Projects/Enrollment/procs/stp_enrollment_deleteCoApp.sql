IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_deleteCoApp')
	BEGIN
		DROP  Procedure  stp_enrollment_deleteCoApp
	END

GO

create procedure [dbo].[stp_enrollment_deleteCoApp]
(
	@coAppID int
)
as
BEGIN
	DELETE FROM tblleadcoapplicant where LeadCoApplicantID = @coAppID
END
