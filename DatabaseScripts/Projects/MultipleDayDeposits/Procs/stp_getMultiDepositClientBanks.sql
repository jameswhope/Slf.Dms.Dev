IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getMultiDepositClientBanks')
	BEGIN
		DROP  Procedure  stp_getMultiDepositClientBanks
	END

GO

CREATE procedure [dbo].[stp_getMultiDepositClientBanks]
(
	@clientid int,
	@BankRoutingNumber nvarchar(9) = NULL,
	@BankAccountNumber nvarchar(50) = NULL
)
as
BEGIN
	IF @BankRoutingNumber IS NULL
		BEGIN
			SELECT     
				cb.BankAccountID
				, rn.CustomerName [BankName]
				, cb.RoutingNumber [BankRoutingNumber]
				, cb.AccountNumber [BankAccountNumber]
				, cb.BankType
				, cb.Disabled
			FROM         
				tblClientBankAccount AS cb 
				INNER JOIN tblRoutingNumber AS rn ON cb.RoutingNumber = rn.RoutingNumber
			WHERE cb.ClientId = @clientid
		END
	IF @BankRoutingNumber IS NOT NULL
		BEGIN
				SELECT     
				cb.BankAccountID
				, rn.CustomerName [BankName]
				, cb.RoutingNumber [BankRoutingNumber]
				, cb.AccountNumber [BankAccountNumber]
				, cb.BankType
				, cb.Disabled
			FROM         
				tblClientBankAccount AS cb 
				INNER JOIN tblRoutingNumber AS rn ON cb.RoutingNumber = rn.RoutingNumber
			WHERE cb.ClientId = @clientid
			AND cb.RoutingNumber = @BankRoutingNumber
			AND cb.AccountNumber = @BankRoutingNumber
		END
END

GRANT EXEC ON stp_getMultiDepositClientBanks TO PUBLIC



