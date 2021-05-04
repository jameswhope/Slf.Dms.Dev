IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateCallMade')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateCallMade
	END

GO

CREATE Procedure stp_Dialer_UpdateCallMade
@CallMadeId int,
@Ended datetime = null,
@ResultId int = null,
@Exception varchar(max) = null,
@CallIdKey varchar(20) = null,
@RetryAfter datetime = null,
@AnsweredDate datetime = null,
@AnsweredBy int = null,
@LastModified datetime = null,
@LastModifiedBy int = null,
@OutboundCallKey varchar(20) = null
AS
Begin

Update tblClient Set
DialerResumeAfter = isnull(@RetryAfter, DialerResumeAfter)
Where ClientId = (Select d.clientid from tblDialerCall d Where d.CallMadeId = @CallMadeId)

Update tblDialerCall Set
Ended = isnull(@Ended, Ended),
ResultId = isnull(@ResultId, ResultId),
Exception = isnull(@Exception, Exception),
CallIdKey = isnull(@CallIdKey, CallIdKey),
RetryAfter = isnull(@RetryAfter, RetryAfter),
AnsweredDate  = isnull(@AnsweredDate, AnsweredDate),
AnsweredBy = isnull(@AnsweredBy, AnsweredBy),
LastModified = isnull(@LastModified, LastModified),
LastModifiedBy = isnull(@LastModifiedBy, LastModifiedBy),
OutboundCallKey = isnull(@OutboundCallKey, OutboundCallKey)
Where CallMadeId = @CallMadeId

End

GO



