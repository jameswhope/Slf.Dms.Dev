IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_InsertCallMade')
	BEGIN
		DROP  Procedure  stp_Dialer_InsertCallMade
	END

GO

CREATE Procedure stp_Dialer_InsertCallMade
@ClientId int,
@PhoneId int,
@ReasonId int,
@WorkGroupQueueId int,
@CreatedBy int = 30,
@PrimaryCallMadeId int = null
AS
Begin
	Update tblClient Set
	DialerResumeAfter = DateAdd(n, 120, GetDate())
	Where clientid = @ClientId
	
	declare @callmadeid int select @callmadeid = null
	
	Insert Into tblDialerCall(ClientId, PhoneId, ReasonId, WorkGroupQueueId, CreatedBy, PrimaryCallMadeId)
	Values (@ClientId, @PhoneId, @ReasonId, @WorkGroupQueueId, @CreatedBy, @PrimaryCallMadeId)
	
	Select @callmadeid = scope_identity()
	
	--if no primary call then set it to itself
	if (isnull(@PrimaryCallMadeId,0) = 0)
	begin
		update tblDialerCall set
		primarycallmadeid = @callmadeid
		where callmadeid = @callmadeid
	end
	--return call id
	Select @callmadeid
End

GO



