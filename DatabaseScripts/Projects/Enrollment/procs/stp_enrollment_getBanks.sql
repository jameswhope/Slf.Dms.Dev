IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_getBanks')
	BEGIN
		DROP  Procedure  stp_enrollment_getBanks
	END

GO

create procedure stp_enrollment_getBanks
(
	@applicantID int
)
as
BEGIN

	select 
		leadbankid
		, bankname
		, accountnumber
		, routingnumber
		, checking
	from 
		tblleadbanks
	where 
		LeadApplicantID  = @applicantID
		
END