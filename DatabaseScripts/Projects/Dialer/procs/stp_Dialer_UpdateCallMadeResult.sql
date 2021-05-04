IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_UpdateCallMadeResult')
	BEGIN
		DROP  Procedure  stp_Dialer_UpdateCallMadeResult
	END

GO

CREATE Procedure stp_Dialer_UpdateCallMadeResult
@CallMadeId int,
@ResultId int,
@CallIdKey varchar(50)
AS
Begin

Declare @RetryAfter datetime 

select @RetryAfter = DateAdd(n, DefaultExpiration, GetDate()) 
from tbldialercallresulttype
Where ResultTypeId = @Resultid

Update tblClient Set
DialerResumeAfter = isnull(@RetryAfter, DialerResumeAfter)
Where ClientId = (Select d.clientid from tblDialerCall d Where d.CallMadeId = @CallMadeId)

Update tblDialerCall Set
ResultId = @ResultId,
RetryAfter = @RetryAfter,
CallIdKey = @CallIdKey,
Ended = Getdate()
Where CallMadeId = @CallMadeId

End

GO
 

