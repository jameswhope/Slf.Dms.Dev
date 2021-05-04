CREATE PROCEDURE [dbo].[stp_VerificationCall_InsertThirdParty]
	@LeadApplicant int,
	@UserId int,
	@CallIdKey varchar(50),
	@LanguageId int = 1
AS
BEGIN
	Insert Into tblVerificationCall(ClientId, LeadApplicantId, ExecutedBy, CallIdKey, LanguageId)
	Values(-1, @LeadApplicant, @UserId, @CallIdKey, @LanguageId)
	Select Scope_identity()
END