IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCallMessageLog')
	BEGIN
		DROP  Procedure  stp_InsertCallMessageLog
	END

GO

CREATE Procedure stp_InsertCallMessageLog
@Message varchar(4000) = Null,
@UserId int
AS
BEGIN
	Insert Into tblCallMessageLog(Message, MessageDate, UserId)
	Values (@Message, GetDate(), @UserId)
	
	Select scope_identity()
END

GO
