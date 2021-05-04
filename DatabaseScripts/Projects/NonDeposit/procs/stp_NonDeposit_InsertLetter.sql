IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertLetter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_InsertLetter
	END

GO

CREATE Procedure stp_NonDeposit_InsertLetter
@NonDepositId int,
@ReplacementId int,
@RegisterId int,
@LetterType varchar(50),
@UserId int
AS
Begin
if not exists(Select NonDepositLetterId from tblnondepositletter where nondepositid = @nondepositid and isnull(replacementid, 0) = isnull(@replacementid, 0) and isnull(RegisterId,0) = isnull(@registerid,0) )
	Insert Into tblNonDepositLetter(NonDepositId, ReplacementId, RegisterId, LetterType, Created, CreatedBy)
	Values  (@NonDepositId, @ReplacementId, @RegisterId, @LetterType, GetDate(), @UserId)
	
	Select scope_identity()
End
	
GO


