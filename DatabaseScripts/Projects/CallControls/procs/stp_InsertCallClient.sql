IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertCallClient')
	BEGIN
		DROP  Procedure  stp_InsertCallClient
	END

GO

CREATE Procedure stp_InsertCallClient
@CallIdKey varchar(20),
@ClientId int
AS
Begin
	if Not Exists(Select ClientId From tblCallClient Where CallIdKey = @CallIdKey )
	Begin
		Insert Into tblCallClient(CallIdKey, ClientId)
		Values (@CallIdKey, @Clientid)
		Select scope_identity()
	End
End

GO



