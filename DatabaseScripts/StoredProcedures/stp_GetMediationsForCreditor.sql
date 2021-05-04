IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = stp_GetMediationsForCreditor')
	BEGIN
		DROP  Procedure  stp_GetMediationsForCreditor
	END

GO

CREATE procedure [dbo].[stp_GetMediationsForCreditor]
	(
		@accountid int
	)

as
	BEGIN
		select
			MediationID
			,Status
			,SettlementAmount
			,SettlementCost
			,cast(SettlementPercentage as int) as SettlementPercentage
			,Savings
			,Created
			,SettlementFee
			,SettlementNotes
		from
			tblmediation 
		where
			accountid = @accountid
		order by created
	END



GO

/*
GRANT EXEC ON stp_GetMediationsForCreditor TO PUBLIC

GO
*/

