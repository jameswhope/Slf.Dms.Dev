IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateCallRecording')
	BEGIN
		DROP  Procedure  stp_UpdateCallRecording
	END

GO

CREATE Procedure stp_UpdateCallRecording
@RecId int,
@RecCallIdKey varchar(20) = null,
@RecFile varchar(1000) = null,
@Reference varchar(20) = null,
@ReferenceId int = null,
@DocTypeId nvarchar(50) = null
AS
Update tblCallRecording Set
RecCallIdKey = isnull(@RecCallIdKey, RecCallIdKey),
RecFile = isnull(@RecFile, RecFile),
Reference = isnull(@Reference, Reference),
ReferenceId = isnull(@ReferenceId, ReferenceId),
DocTypeId = isnull(@DocTypeId, DocTypeId) 
Where RecId = @RecId

GO



