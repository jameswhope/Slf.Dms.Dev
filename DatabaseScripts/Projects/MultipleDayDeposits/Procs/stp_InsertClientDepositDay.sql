IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertClientDepositDay')
	BEGIN
		DROP  Procedure  stp_InsertClientDepositDay
	END

GO

CREATE Procedure stp_InsertClientDepositDay
(
	@ClientId int,
	@Frequency varchar(10),
	@DepositDay int,
	@Amount money,
	@Occurrence int = NULL,
	@DepositMethod varchar(50),
	@DepositMethodDisplay varchar(15),
	@BankAccountId int = NULL,
	@UserId int
)
AS
Begin
	Insert Into tblCLientDepositDay(ClientId, Frequency, DepositDay, DepositAmount, Occurrence, Created, CreatedBy, LastModified, LastModifiedBy, DepositMethod, BankAccountId, DepositMethodDisplay) 
	Values (@ClientId, @Frequency, @DepositDay, @Amount, @Occurrence, GetDate(), @UserId, GetDate(), @UserId, @DepositMethod, @BankAccountId, @DepositMethodDisplay) 
	
	select scope_identity()
End
GO


