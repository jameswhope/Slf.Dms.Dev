IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_GetLeadInfo')
	BEGIN
		DROP  Procedure  stp_VerificationCall_GetLeadInfo
	END

GO

CREATE Procedure stp_VerificationCall_GetLeadInfo
@VerificationId int
AS
	Select v.ClientId,
	AccountNumber = 'Lead Applicant',
	isnull(l.FirstName,'') + ' ' + isnull(l.LastName,'') as [FullName],
	v.LanguageId,
	v.callidkey,
	isnull(u.firstname,'') + ' ' + isnull(u.lastname,'') as [VerifiedBy]
	From tblVerificationCall v
	inner join tblleadapplicant l on l.leadapplicantid = v.leadapplicantid
	inner join tbluser u on u.userid = v.executedby
	Where v.VerificationCallId = @VerificationId

GO