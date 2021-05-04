IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertPhoneStatusLog')
	BEGIN
		DROP  Procedure  stp_InsertPhoneStatusLog
	END

GO

CREATE Procedure stp_InsertPhoneStatusLog
@StatusName varchar(100),
@UserId int
AS
BEGIN
	Insert Into tblPhoneStatusLog(StatusName, Created, UserId)
	Values (@StatusName, GetDate(), @UserId)
	
	Select scope_identity()
END

GO
