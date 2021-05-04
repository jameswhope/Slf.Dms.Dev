IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateClientDepositDay')
	BEGIN
		DROP  Procedure  stp_UpdateClientDepositDay
	END

GO

CREATE Procedure stp_UpdateClientDepositDay
(
	@ClientDepositId int,
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
	Update tblCLientDepositDay Set
	ClientId = @ClientId,
	Frequency = @Frequency,
	DepositDay = @DepositDay,
	DepositAmount = @Amount,
	Occurrence = @Occurrence,
	DepositMethod = @DepositMethod,
	DepositMethodDisplay = @DepositMethodDisplay,
	BankAccountId = @BankAccountId,
	LastModified = GetDate(),
	LastModifiedBy = @UserId
	Where ClientDepositId = @ClientDepositId 

GO
