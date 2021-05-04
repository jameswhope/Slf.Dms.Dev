IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_ReplicateBankAccountUpdate')
	BEGIN
		DROP  Procedure  stp_ReplicateBankAccountUpdate
	END

GO

CREATE Procedure stp_ReplicateBankAccountUpdate
@BankAccountId as Integer,
@UserId as Integer 
AS
Begin
	Declare @routing varchar(50)
	Declare @account varchar(50)
	Declare @bank varchar(50)
	Declare @banktype varchar(1)
	
	Select @routing = b.RoutingNumber, @account = b.AccountNumber, @banktype = b.BankType, @bank = isnull(r.CustomerName, '')  from tblClientBankAccount b
	left join tblRoutingNumber r on b.RoutingNumber = r.RoutingNumber
	Where b.BankAccountId = @BankAccountId
	
	Update tblAdhocAch Set
	BankRoutingNumber = @routing,
	BankAccountNumber = @account,
	BankType = @bankType,
	BankName = @bank,
	LastModified = GetDate(),
	LastModifiedBy = @UserId
	Where  registerid is null
	and  bankaccountid = @BankAccountId
End
GO

