IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_Insert')
	BEGIN
		DROP  Procedure  stp_VerificationCall_Insert
	END

GO

CREATE Procedure stp_VerificationCall_Insert
@ClientId int,
@UserId int,
@CallIdKey varchar(50),
@LanguageId int = 1
AS
BEGIN
	Insert Into tblVerificationCall(ClientId, ExecutedBy, CallIdKey, LanguageId)
	Values(@ClientId, @UserId, @CallIdKey, @LanguageId)
	Select Scope_identity()
END

GO



