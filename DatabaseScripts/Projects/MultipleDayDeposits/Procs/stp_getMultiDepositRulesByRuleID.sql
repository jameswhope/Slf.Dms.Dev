IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getMultiDepositRulesByRuleID')
	BEGIN
		DROP  Procedure  stp_getMultiDepositRulesByRuleID
	END

GO

create procedure [dbo].[stp_getMultiDepositRulesByRuleID]
(
	@ACHRuleID int
)
as
BEGIN
	SELECT dr.RuleACHId
		 , ba.AccountNumber AS BankAccountNumber
		 , ba.RoutingNumber AS BankRoutingNumber
		 , rn.CustomerName AS BankName
		 , dr.DepositAmount
		 , dr.DepositDay
		 , dr.StartDate
		 , dr.EndDate
		 , ba.BankType
		 , dr.ClientDepositID
		 , ba.BankAccountId
		 , ba.Disabled AS [Disabled]
		 , isnull(left(u.FirstName, 1) + '. ' + u.LastName,'') AS [uCreatedBy]
		 , dr.Created
		 , isnull(left(u1.FirstName, 1) + '. ' + u1.LastName,'') AS [uLastModifiedBy]
		 , dr.LastModified
	FROM
		tblDepositRuleAch AS dr
		INNER JOIN tblClientBankAccount AS ba
			ON dr.BankAccountID = ba.BankAccountId
		INNER JOIN tblRoutingNumber AS rn
			ON ba.RoutingNumber = rn.RoutingNumber
		LEFT JOIN tblUser u
			ON u.userid = dr.CreatedBy
		LEFT JOIN tblUser u1
			ON u1.userid = dr.LastModifiedBy
	WHERE
		dr.RuleACHId = @ACHRuleID
		
END




GRANT EXEC ON stp_getMultiDepositRulesByRuleID TO PUBLIC




 