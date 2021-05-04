IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateLeadCall')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateLeadCall
	END

GO

CREATE Procedure stp_Dialer_UpdateLeadCall
@CallMadeId int,
@Exception varchar(max) = null,
@CallIdKey varchar(20) = null,
@OutboundCallKey varchar(20) = null,
@PickedupDate datetime = null,
@PickedupBy int = null,
@ResultId int = null
AS
Update tblLeadDialerCall Set
Exception = isnull(@Exception, Exception),
CallIDKey = isnull(@CallIdKey, CallIdKey),
OutboundCallKey = isnull(@OutboundCallKey, OutboundCallKey),
PickedupDate = isnull(@PickedupDate, PickedupDate),
PickedupBy = isnull(@PickedupBy, PickedupBy),
ResultId = isnull(@ResultId, ResultId)
Where CallMadeId = @CallMadeId

GO



