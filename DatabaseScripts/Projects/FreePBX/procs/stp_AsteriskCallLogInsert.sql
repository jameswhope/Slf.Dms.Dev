IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AsteriskCallLogInsert')
	BEGIN
		DROP  Procedure  stp_AsteriskCallLogInsert
	END

GO

CREATE Procedure stp_AsteriskCallLogInsert
@PhoneNumber varchar(20),
@UserId int,
@Inbound bit,
@CallerId varchar(20) = null,
@RefType varchar(20) = null,
@RefId int = null,
@PhoneSystem varchar(50) = null,
@CallReasonId int = 0
AS
Begin
	declare @refdate datetime, @refby int
	if @RefType is null
		select @refdate = null, @refby = null
	else
		select @refdate = Getdate(), @refby = @UserId

	insert into tblAstCallLog(PhoneNumber, Inbound, UserId, CallerId, RefType, RefId, PhoneSystem, CallReasonId)
	Values (@PhoneNumber, @Inbound, @UserId, @CallerId, @RefType, @RefId, @PhoneSystem, @CallReasonId)
	
	Select scope_identity()
End 

GO

 

