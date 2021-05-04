IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DialerUpdateCallResolution')
	BEGIN
		DROP  Procedure  stp_DialerUpdateCallResolution
	END

GO

CREATE Procedure stp_DialerUpdateCallResolution
@CallResolutionId int,
@Expiration datetime = null,
@RecordingId int = null,
@UserId int
AS
Update tblDialerCallResolution Set
Expiration = isnull(@Expiration, Expiration),
RecordingId = isnull(@RecordingId, RecordingId),
LastModified = GetDate(),
LastModifiedBy = @UserId
Where CallResolutionId = @CallResolutionId


GO


