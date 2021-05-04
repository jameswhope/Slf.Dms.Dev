IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCallLog_Insert')
	BEGIN
		DROP  Procedure  stp_VerificationCallLog_Insert
	END

GO

CREATE Procedure stp_VerificationCallLog_Insert
@VerificationCallId int,
@QuestionNo int,
@AnsweredNo bit
AS
Begin
 Insert Into tblVerificationCallLog (VerificationCallId, QuestionNo, AnsweredNo)
 Values (@VerificationCallId, @QuestionNo, @AnsweredNo)
 
 Select scope_identity()
End			 

GO



