IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_UpdateLetter')
	BEGIN
		DROP  Procedure  stp_NonDeposit_UpdateLetter
	END

GO

CREATE Procedure stp_NonDeposit_UpdateLetter
@NonDepositLetterId int,
@LetterType varchar(50) = null,
@PrintedDate datetime = null,
@PrintedBy int = null,
@SentToEmail bit = null,
@Filename varchar(1000) = null
AS
Begin
	Update tblNonDepositLetter Set
	LetterType = isnull(@LetterType, LetterType),
	PrintedDate = isnull(@PrintedDate, PrintedDate),
	PrintedBy = isnull(@PrintedBy, PrintedBy),
	SentToEmail = isnull(@SentToEmail, SentToEmail),
	[FileName] = isnull(@Filename, [Filename])
	Where NonDepositLetterId =	@NonDepositLetterId		
End 

GO


