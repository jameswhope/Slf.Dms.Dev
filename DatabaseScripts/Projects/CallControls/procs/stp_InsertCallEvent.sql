IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCallEvent')
	BEGIN
		DROP  Procedure  stp_InsertCallEvent
	END

GO

CREATE Procedure stp_InsertCallEvent
@CallIdKey varchar(50) = Null,
@PhoneNumber varchar(50) = Null,
@EventName varchar(50),
@UserId int
AS
BEGIN
	Insert Into tblCallLog(CallIdKey, PhoneNumber, EventName, EventDate, EventBy)
	Values (@CallIdKey, @PhoneNumber, @EventName, GetDate(), @UserId)
	
	Select scope_identity()
END

GO