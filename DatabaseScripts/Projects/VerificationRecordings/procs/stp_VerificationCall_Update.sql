IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_VerificationCall_Update')
	BEGIN
		DROP  Procedure  stp_VerificationCall_Update
	END

GO

CREATE Procedure stp_VerificationCall_Update
@VerificationCallId int,
@EndDate datetime = null,
@Completed bit = null,
@RecCallIdKey varchar(50) = null,
@RecordedCallPath varchar(1000) = null,
@LastStep varchar(50) = null,
@DocumentPath varchar(100) = null,
@ViciFileName varchar(255) = null
AS
Update tblVerificationCall Set
EndDate = isnull(@EndDate, EndDate)	,
Completed = isnull(@Completed, Completed),
RecCallIdKey = isnull(@RecCallIdKey, RecCallIdKey),
RecordedCallPath = isnull(@RecordedCallPath, RecordedCallPath),
LastStep = isnull(@LastStep, LastStep),
DocumentPath = isnull(@DocumentPath, DocumentPath),
ViciFileName = isnull(@ViciFileName, ViciFileName)
Where VerificationCallId = @VerificationCallId																	

GO


