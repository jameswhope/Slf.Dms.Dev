IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[stp_Delete_MultiDeposits]' AND OBJECTPROPERTY(id,N'IsProcedure')=1)
DROP PROCEDURE [dbo].[stp_Delete_MultiDeposits]
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 03/10/2009
-- Description:	Insert MultiDeposit information in tables
-- =============================================
CREATE PROCEDURE stp_Delete_MultiDeposits 
	@ClientID int, 
	@DepositDay int,
	@DepositAmount money,
	@UserID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @BankAccountNumber nvarchar(50)
	DECLARE @BankRoutingNumber nvarchar(9)
	DECLARE @BankAccountId int

--Gather necessary data
	SELECT 
	@BankAccountNumber = BankAccountNumber, 
	@BankRoutingNumber = BankRoutingNumber 
	FROM tblClient
	WHERE ClientID = @ClientID
	SELECT
	@BankAccountId = BankAccountId
	FROM tblClientBankAccount
	WHERE ClientId = @ClientID
	
--Update the client to multi deposit = false
	UPDATE tblClient SET MultiDeposit = 0 WHERE ClientID = @ClientID
--Delete bank account information for Multi deposit
	--NO CAN DO.........................
--Insert additional deposit information in deposit day(s) table
	DELETE tblClientDepositDay
	WHERE ClientID = @ClientID
	AND DeposistDay = @DepositDay
	AND DepositAmount = @DepositAmount
	
END
GO