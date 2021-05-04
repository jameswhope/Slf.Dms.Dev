IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_DialerUpdateAM')
	BEGIN
		DROP  Procedure  stp_DialerUpdateAM
	END

GO

CREATE Procedure stp_DialerUpdateAM
@CallIdKey varchar(20),
@LeftMessage bit
AS
BEGIN

Declare @ResultId int   
Declare @RetryAfter datetime 
Declare @ResultType varchar(20)

Select @ResultType = Case When @LeftMessage = 1 Then 'Message' Else 'Machine' End  

select @ResultId = ResultTypeId,
@RetryAfter = DateAdd(n, DefaultExpiration, GetDate()) 
from tbldialercallresulttype
Where Result = @ResultType

Update tblClient Set
DialerResumeAfter = isnull(@RetryAfter, DialerResumeAfter)
Where ClientId = (Select d.clientid from tblDialerCall d Where d.CallIdKey = @CallIdKey)

Update tblDialerCall Set
ResultId = isnull(@ResultId, ResultId),
RetryAfter = isnull(@RetryAfter, RetryAfter)
Where CallIdKey = @CallIdKey

END
GO