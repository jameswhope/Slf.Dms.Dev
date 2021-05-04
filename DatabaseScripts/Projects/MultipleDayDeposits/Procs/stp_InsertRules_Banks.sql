-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
IF EXISTS (SELECT * FROM sysobjects 
WHERE type = 'P'
AND name = 'stp_InsertRules_Banks') 
		DROP PROCEDURE [dbo].[stp_InsertRules_Banks]
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 3/12/2009
-- Description:	Post new rules and accounts if any
-- =============================================
CREATE PROCEDURE stp_ConvertRules_BankAccts 
	-- Add the parameters for the stored procedure here
	@ClientID int , 
	@UserID int  
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @NumBanks int
	DECLARE @i int
	DECLARE @BankAccountNumber nvarchar(50)
	DECLARE @BankRoutingNumber nvarchar(9)
	DECLARE @BankType char(1)
	DECLARE @BankId int
	DECLARE @BankAccountId int
	DECLARE @DepositDay int
	DECLARE @DepositMethod nvarchar(10)
	DECLARE @DepositAmount money
	DECLARE @StartDate datetime
	DECLARE @EndDate datetime
	DECLARE @ClientDepositId int

	SET @BankAccountNumber = ''
	SET @BankRoutingNumber = ''
	SET @BankType = ''
	SET @BankAccountId = 0
--Gather all current and future rules for a single Client
DECLARE @CurrentRules TABLE 
( ClientID int,
RuleACHId int,
StartDate datetime,
EndDate datetime,
DepositDay int,
DepositAmount money,
BankName nvarchar(50),
RRoutingNumber nvarchar(9),
RAccountNumber nvarchar(50),
RBankType varchar(1),
CRoutingNumber nvarchar(9),
CAccountNumber nvarchar(50),
BankType nvarchar(1),
BankAccountID int,
ClientDepositID int
)
--Setup the working table
INSERT INTO @CurrentRules
SELECT c.ClientID,
ra.RuleACHId, 
ra.StartDate, 
ra.EndDate, 
ra.DepositDay,
ra.DepositAmount, 
ra.BankName, 
rtrim(ltrim(ra.BankRoutingNumber)),
rtrim(ltrim(ra.BankAccountNumber)),
CASE WHEN ra.BankType IS NOT NULL THEN ra.BankType ELSE 'C' END, 
rtrim(ltrim(c.BankRoutingNumber)), 
rtrim(ltrim(c.BankAccountNumber)),
c.BankType,
cd.BankAccountId,
cd.ClientDepositId 
FROM tblruleach ra 
INNER JOIN tblClient c ON c.clientid = ra.clientid
LEFT JOIN tblClientDepositDay cd ON cd.clientid = ra.clientid
WHERE  c.ClientID = @ClientID
AND ra.enddate > getdate() 
AND ra.startdate < dateadd(year, 10, getdate())
ORDER BY ra.RuleACHId
--Same bank account
SELECT 
				@BankAccountNumber = RAccountNumber, 
				@BankRoutingNumber = RRoutingNumber,
				@BankType = RBankType,
				@StartDate = StartDate,
				@EndDate = EndDate,
				@DepositAmount = DepositAmount, 
				@BankAccountId = BankAccountId,
				@ClientDepositId = ClientDepositId
				FROM @CurrentRules 
				WHERE RRoutingNumber + RAccountNumber = CRoutingNumber + CAccountNumber
				--Add rules to tblDepositRuleAch where the bank account numbers are the same no need to create another bank account
				INSERT INTO tblDepositRuleACH
				(StartDate,
					EndDate,
					DepositDay,
					DepositAmount,
					Created,
					CreatedBy,
					LastModified,
					LastModifiedBy,
					ClientDepositId,
					BankAccountId)
					VALUES(@StartDate,
					@EndDate,
					@DepositDay,
					@DepositAmount,
					getdate(),
					@UserID,
					getdate(),
					@UserId,
					@ClientDepositId,
					@BankAccountId)
--Different bank accounts
			SELECT 
				@BankAccountNumber = RAccountNumber, 
				@BankRoutingNumber = RRoutingNumber,
				@BankType = RBankType,
				@StartDate = StartDate,
				@EndDate = EndDate,
				@DepositAmount = DepositAmount, 
				@BankAccountId = BankAccountId,
				@ClientDepositId = ClientDepositId
				FROM @CurrentRules 
				WHERE RRoutingNumber + RAccountNumber <> CRoutingNumber + CAccountNumber
				--Add rules to tblDepositRuleAch where the bank account numbers are not the same
	SELECT @NumBanks = count(*) FROM tbl@CurrentRules
		WHILE (@i <= @NumBanks)
		BEGIN
				INSERT INTO tblClientBankAccount
				(ClientId,
				RoutingNumber,
				AccountNumber,
				BankType,
				Created,
				CreatedBy,
				LastModified,
				LastModifiedBy)
				VALUES
				(@ClientID,
				@BankRoutingNumber,
				@BankAccountNumber,
				@BankType,
				getdate(),
				@UserID,
				getdate(),
				@UserID)
				SELECT @BankAccountId = scope_Identity()
				--Insert the rule
				INSERT INTO tblDepositRuleACH
				(StartDate,
					EndDate,
					DepositDay,
					DepositAmount,
					Created,
					CreatedBy,
					LastModified,
					LastModifiedBy,
					ClientDepositId,
					BankAccountId)
					VALUES(@StartDate,
					@EndDate,
					@DepositDay,
					@DepositAmount,
					getdate(),
					@UserID,
					getdate(),
					@UserId,
					@ClientDepositId,
					@BankAccountId)
				SET @i = @i + 1
			END
			
--No Previous bank account setup bank account then setup - hold for later
--		SELECT 
--				@BankAccountNumber = RAccountNumber, 
--				@BankRoutingNumber = RRoutingNumber,
--				@BankType = RBankType,
--				@StartDate = StartDate,
--				@EndDate = EndDate,
--				@DepositAmount = DepositAmount, 
--				@BankAccountId = BankAccountId,
--				@ClientDepositId = ClientDepositId
--				FROM @CurrentRules 
--				WHERE RRoutingNumber IS NOT NULL
--				AND CRoutingNumber IS NULL 
--				--Add rules to tblDepositRuleAch where the bank account numbers are the same no need to create another bank account
--				INSERT INTO tblDepositRuleACH
--				(StartDate,
--					EndDate,
--					DepositDay,
--					DepositAmount,
--					Created,
--					CreatedBy,
--					LastModified,
--					LastModifiedBy,
--					ClientDepositId,
--					BankAccountId)
--					VALUES(@StartDate,
--					@EndDate,
--					@DepositDay,
--					@DepositAmount,
--					getdate(),
--					@UserID,
--					getdate(),
--					@UserId,
--					@ClientDepositId,
--					@BankAccountId)
--Mulitple matching rules, pick the latest one as the over ridding one
--SELECT TOP 1 * FROM @CurrentRules
--WHERE StartDate IN (SELECT StartDate FROM @CurrentRules)
--ORDER BY RuleACHId DESC
END
GO
