IF EXISTS (SELECT * FROM sysobjects 
WHERE type = 'P'
AND name = 'stp_Insert_MultiDeposits') 
		DROP PROCEDURE [dbo].[stp_Insert_MultiDeposits]
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 03/10/2009
-- Description:	Insert MultiDeposit information in tables
-- =============================================
CREATE PROCEDURE stp_Insert_MultiDeposits 
	@ClientID int, 
	@DepositDay int,
	@DepositAmount money,
	@UserID int = 0,
	@Frequency nvarchar(10) = 'month',
	@Occurrence int = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @BankAccountNumber nvarchar(50)
	DECLARE @BankRoutingNumber nvarchar(9)
	DECLARE @BankType char(1)
	DECLARE @BankId int
	DECLARE @DepositMethod nvarchar(50)
	DECLARE @BankAccountId int

	SET @BankAccountNumber = ''
	SET @BankRoutingNumber = ''
	SET @BankType = ''
	SET @BankAccountId = 0

--Gather necessary data
	SELECT 
	@BankAccountNumber = BankAccountNumber, 
	@BankRoutingNumber = BankRoutingNumber, 
	@BankType = BankType,
	@DepositMethod = DepositMethod
	FROM tblClient
	WHERE ClientID = @ClientID
--Update the client to multi deposit
	UPDATE tblClient SET MultiDeposit = 1 WHERE ClientID = @ClientID
--Insert bank account information for Multi deposit
	INSERT INTO tblClientBankAccount
	(
	ClientID,
	RoutingNumber,
	AccountNumber,
	BankType,
	Created,
	CreatedBy,
	LastModified,
	LastModifiedBy
	)
	VALUES
	(
	@ClientID,
	@BankRoutingNumber,
	@BankAccountNumber,
	@BankType,
	getdate(),
	@UserID,
	getdate(),
	@UserID
	)	
    SELECT @BankAccountID = scope_identity()
--Insert additional deposit information in deposit day(s) table
	INSERT INTO tblClientDepositDay
	(
	ClientID,
	Frequency,
	DepositDay,
	Occurrence,
	DepositAmount,
	Created,
	CreatedBy,
	LastModified,
	LastModifiedBy,
	BankAccountId,
	DepositMethod
	)
	VALUES
	(
	@ClientID,
	@Frequency,
	@DepositDay,
	@Occurrence,
	@DepositAmount,
	getdate(),
	@UserID,
	getdate(),
	@UserID,
	@BankAccountId,
	@DepositMethod
	)
	
END
GO