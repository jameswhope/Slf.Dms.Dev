IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_GetI3FilePath')
	BEGIN
		DROP  Procedure  stp_VerificationCall_GetI3FilePath
	END

GO

CREATE Procedure stp_VerificationCall_GetI3FilePath
@RecCallIdKey varchar(50)
AS
	Select RecordingFileName from dbo.RecordingData
where CallIdKey = @RecCallIdKey
	

GO

