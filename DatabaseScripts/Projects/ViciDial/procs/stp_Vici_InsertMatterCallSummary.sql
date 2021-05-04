IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_InsertMatterCallSummary')
	BEGIN
		DROP  Procedure  stp_Vici_InsertMatterCallSummary
	END

GO

CREATE Procedure stp_Vici_InsertMatterCallSummary
@MatterId int,
@ReasonId int,
@CallDate datetime = null
AS
Begin
	declare @MatterCallLogId int Set @MatterCallLogId = null
	select @CallDate = isnull(@CallDate,GetDate())
	
	select @MatterCallLogId = MatterCallLogId
	from tblViciMatterCallSummary
	where matterid = @matterid
	and reasonid = @reasonid
	and convert(varchar(10),CallDate,101) = convert(varchar(10),@CallDate, 101)
	
	if @MatterCallLogId is null 
		begin
			Insert Into tblViciMatterCallSummary(MatterId, ReasonId, CallDate, LastCallDate)
			Values(@MatterId, @ReasonId, convert(varchar(10),@CallDate, 120), @CallDate)
			Select scope_identity()
		end
	else
		begin
			Update tblViciMatterCallSummary Set
			LastCallDate = @CallDate,
			DayCallCount = DayCallCount + 1
			where MatterCallLogId = @MatterCallLogId
			Select @MatterCallLogId
		end
End

GO
