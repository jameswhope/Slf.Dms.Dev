IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetMultiDepositCheckRules')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetMultiDepositCheckRules
	END

GO

create procedure [dbo].[stp_NonDeposit_GetMultiDepositCheckRules]
(
	@ClientID int,
	@additionalWhereClause varchar(max)
)
as
BEGIN
	exec('
		SELECT     
			dr.RuleCheckId
			, dr.DepositAmount
			, dr.DepositDay
			, dr.StartDate
			, dr.EndDate
			, dr.DateUsed
			, cd.Depositday [OriginalDepositDay]
			, cd.Deleteddate [DeletedDate]
			, dr.Locked
		FROM         
			tblDepositRuleCheck AS dr 
			Left join tblClientDepositDay as cd on cd.clientdepositid = dr.clientdepositid
		WHERE 
			dr.ClientDepositId in (select ClientDepositID from [tblClientDepositDay] where clientid = ' + @ClientID + ')' 
			+ @additionalWhereClause + ' Order By dr.StartDate desc, dr.EndDate desc'
		)
END

 


