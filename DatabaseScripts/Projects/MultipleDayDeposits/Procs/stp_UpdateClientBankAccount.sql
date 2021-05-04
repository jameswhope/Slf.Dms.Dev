IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateClientBankAccount')
	BEGIN
		DROP  Procedure  stp_UpdateClientBankAccount
	END

GO

CREATE Procedure stp_UpdateClientBankAccount
@BankAccountId int,
@ClientId int,
@Routing varchar(9),
@Account varchar(50),
@BankType varchar(1),
@UserId int
AS
BEGIN
	Update tblClientBankAccount Set
	RoutingNumber = @Routing,
	AccountNumber = @Account,
	BankType = @BankType,
	LastModified = GetDate(),
	LastModifiedBy = @UserId
	Where BankAccountId = @BankAccountId and ClientId = @ClientId
END


