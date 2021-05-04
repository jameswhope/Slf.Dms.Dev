IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPendingSettlementsForClient')
	BEGIN
		DROP  Procedure  stp_GetPendingSettlementsForClient
	END

GO

CREATE Procedure [dbo].[stp_GetPendingSettlementsForClient]
(
@ClientId int
)

AS
BEGIN

	SELECT 
		s.SettlementAmount, 
		s.SettlementDueDate, 
		s.SettlementPercent, 
		isnull(s.AvailSDA, 0) AS RegisterBalance,
		c.PFOBalance, 
		c.SettlementFeePercentage,
		(p.FirstName + ' '+ p.LastName) AS ClientName, 
		cr.Name AS CreditorName, 
		ci.AccountNumber, 
		s.CreditorAccountBalance AS AccountBalance, 
		s.SettlementFee, 
		s.SettlementSavings, 
		s.SettlementFeeCredit, 
		(CASE 
			WHEN s.DeliveryAmount is null THEN s.OvernightDeliveryAmount 
			ELSE s.DeliveryAmount 
		END) AS DeliveryFee, 
		msc.MatterSubStatus AS Status, 
		s.SettlementAmount,
		s.SettlementAmtAvailable,
		s.SettlementAmtBeingSent,
		s.SettlementAmtStillOwed,
		s.SettlementCost,
		s.SettlementFeeAmtAvailable,
		s.SettlementFeeAmtBeingPaid,
		s.SettlementFeeAmtStillOwed,
		s.settlementid,
		m.matterstatuscodeid
	FROM 
		tblSettlements s 
		INNER JOIN tblClient c ON s.ClientId = c.ClientId 
		INNER JOIN tblMatter m ON m.MatterId = s.MatterId
		INNER JOIN tblMatterStatusCode ms ON ms.MatterStatusCodeId = m.MatterStatusCodeId
		INNER JOIN tblMatterSubStatus msc ON msc.MatterSubStatusId = m.MatterSubStatusId
		INNER JOIN tblPerson p ON p.PersonId = c.PrimaryPersonId 
		INNER JOIN tblAccount a ON a.AccountId = s.CreditorAccountId 
		INNER JOIN tblCreditorInstance ci ON ci.CreditorInstanceId = a.CurrentCreditorInstanceId 
		INNER JOIN tblCreditor cr ON cr.CreditorId = ci.CreditorId 
	WHERE 
		s.ClientId= @ClientId and m.matterstatuscodeid <> 37 and m.isdeleted <> 1 and datediff(d,s.settlementduedate,getdate())<=0
	ORDER BY s.SettlementSavings DESC

END 
GO


GRANT EXEC ON stp_GetPendingSettlementsForClient TO PUBLIC

GO


