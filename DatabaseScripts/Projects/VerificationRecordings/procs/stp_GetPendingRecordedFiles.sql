IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPendingRecordedFile')
	BEGIN
		DROP  Procedure  stp_GetPendingRecordedFile
	END

GO

CREATE Procedure stp_GetPendingRecordedFile
AS
Begin
	Select VerificationCallId, RecCallIdKey, ClientId, ExecutedBy
	From tblVerificationCall
	Where Completed = 1
	and isnull(RecordedCallPath,'') = ''

End

GO


