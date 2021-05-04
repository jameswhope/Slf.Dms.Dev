 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_GetQuestions')
	BEGIN
		DROP  Procedure  stp_VerificationCall_GetQuestions
	END

GO

CREATE Procedure stp_VerificationCall_GetQuestions
@LanguageId int = null,
@VersionId int 
AS
Select [Order] as QuestionNo, Case When @LanguageId = 1 Then QuestionTextEN Else QuestionTextSP End as  QuestionText, FailWhenNo from  tblVerificationQuestion
Where VersionId = @VersionId
Order By [Order] Asc

GO