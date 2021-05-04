 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertClientBankAccount')
	BEGIN
		DROP  Procedure  stp_InsertClientBankAccount
	END

GO

CREATE Procedure [dbo].[stp_InsertClientBankAccount]
(
@ClientId int,
@Routing varchar(9),
@Account varchar(50),
@BankType varchar(1),
@UserId int
)
AS
BEGIN
	--Do not allow duplicate bank accounts
	declare @bankId int
	select @bankid = null
	
	select top 1 @bankid = BankAccountId 
	from tblClientBankAccount 
	where ClientId = @ClientId And RoutingNumber = @Routing and AccountNumber = @Account and [Disabled] Is Null
	
	If @bankid is null
	Begin
		insert into tblClientBankAccount(ClientId, RoutingNumber, AccountNumber, BankType, CreatedBy, LastModified, LastModifiedBy)
		values (@ClientId, @Routing, @Account, @BankType, @UserID, GetDate(), @UserId)
		
		select scope_identity()
	End
	Else
		select @bankid
END



GRANT EXEC ON stp_InsertClientBankAccount TO PUBLIC




 