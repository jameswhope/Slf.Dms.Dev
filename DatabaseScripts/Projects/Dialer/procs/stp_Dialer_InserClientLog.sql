IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertClientLog')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertClientLog
	END

GO

CREATE Procedure stp_Dialer_InsertClientLog
@ClientId int,
@ReasonId int,
@CallDate datetime = null
AS
Begin
	declare @DialerClientLogId int Set @DialerClientLogId = null
	select @CallDate = isnull(@CallDate,GetDate())
	
	select @DialerClientLogId = DialerClientLogId 
	from tblDialerClientLogSummary
	where clientid = @clientid
	and reasonid = @reasonid
	and convert(varchar(10),LastCallDate,101) = convert(varchar(10),@CallDate, 101)
	
	if @DialerClientLogId is null 
		begin
			Insert Into tblDialerClientLogSummary(ClientId, ReasonId, CallDate, LastCallDate)
			Values(@ClientId, @ReasonId, convert(varchar(10),@CallDate, 120), @CallDate)
			Select scope_identity()
		end
	else
		begin
			Update tblDialerClientLogSummary Set
			LastCallDate = @CallDate,
			DayCallCount = DayCallCount + 1
			where DialerClientLogId = @DialerClientLogId
			Select @DialerClientLogId
		end
End

GO
