IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getMultiDepositRules')
	BEGIN
		DROP  Procedure  stp_getMultiDepositRules
	END

GO

create procedure [dbo].[stp_getMultiDepositRules]
(
	@ClientID int,
	@additionalWhereClause varchar(max)
)
as
BEGIN
	exec('
		SELECT     
			dr.RuleACHId
			, ba.AccountNumber AS BankAccountNumber
			, ba.RoutingNumber AS BankRoutingNumber
			, rn.CustomerName AS BankName
			, dr.DepositAmount
			, dr.DepositDay
			, dr.StartDate
			, dr.EndDate
			, cd.Depositday [OriginalDepositDay]
			, cd.Deleteddate [DeletedDate]
			, dr.Locked
		FROM         
			tblDepositRuleAch AS dr 
			INNER JOIN tblClientBankAccount AS ba ON dr.BankAccountID = ba.BankAccountId 
			INNER JOIN tblRoutingNumber AS rn ON ba.RoutingNumber = rn.RoutingNumber
			Left join tblClientDepositDay as cd on cd.clientdepositid = dr.clientdepositid
		WHERE 
			dr.ClientDepositId in (select ClientDepositID from [tblClientDepositDay] where clientid = ' + @ClientID + ')' 
			+ @additionalWhereClause + ' Order By dr.StartDate desc, dr.EndDate desc'
		)
END


GRANT EXEC ON stp_getMultiDepositRules TO PUBLIC


