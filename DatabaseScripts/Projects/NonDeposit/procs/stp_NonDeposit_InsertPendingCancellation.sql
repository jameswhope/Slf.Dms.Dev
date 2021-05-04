IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_InsertPendingCancellation')
	BEGIN
		DROP  Procedure  Stored_Procedure_Name
	END

GO

CREATE Procedure stp_NonDeposit_InsertPendingCancellation
@Clientid int,
@Userid int
AS
Begin
	
	If Not Exists(Select ClientId From tblNonDepositPendingCancellation Where clientid = @clientid and deleted is null)
	begin
		insert into tblNonDepositPendingCancellation(ClientId, Created, CreatedBy)
		values (@clientid, GetDate(), @UserId)
	End
End

GO



