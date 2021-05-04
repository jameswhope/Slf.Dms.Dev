IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAccountingInformation')
	BEGIN
		DROP  Procedure  stp_GetAccountingInformation
	END

GO

CREATE Procedure [dbo].[stp_GetAccountingInformation]
(
	@MatterId int	
)
AS
BEGIN
	
	SELECT acc.MatterId,
			m.ClientId,
			m.MatterTypeId,
		   m.MatterSubStatusId,
			m.MatterStatusCodeId,
			m.MatterStatusId,	
			m.MatterDate,		
			ms.MatterStatus,
			msc.MatterStatusCode,
			mss.MatterSubStatus,
			m.CreditorInstanceId,
			a.AccountId,
			acc.PaymentProcessingId,
			acc.DueDate,
			acc.CheckNumber,
			acc.DeliveryMethod,
			acc.Processed,
			acc.ReferenceNumber,
			acc.CheckAmount,
			acc.IsApproved,
			acc.ProcessedDate,
			acc.IsCheckprinted,
			(CASE
				WHEN ad.DeliveryAddress is null and m.MatterTypeId = 3 THEN 
							(SELECT DeliveryAddress FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.DeliveryAddress
			END) As DeliveryAddress,			
			(CASE
				WHEN ad.DeliveryCity is null and m.MatterTypeId = 3 THEN 
							(SELECT DeliveryCity FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.DeliveryCity
			END) As DeliveryCity,	
			(CASE
				WHEN ad.DeliveryState is null and m.MatterTypeId = 3 THEN 
							(SELECT DeliveryState FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.DeliveryState
			END) As DeliveryState,	
			(CASE
				WHEN ad.DeliveryZip is null and m.MatterTypeId = 3 THEN 
							(SELECT DeliveryZip FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.DeliveryZip
			END) As DeliveryZip,	
			(CASE
				WHEN ad.DeliveryPhone is null and m.MatterTypeId = 3 THEN 
							(SELECT DeliveryPhone FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.DeliveryPhone
			END) As DeliveryPhone,	
			ad.DeliveryFax,
			(CASE
				WHEN ad.DeliveryEmail is null and m.MatterTypeId = 3 THEN 
							(SELECT DeliveryEmail FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.DeliveryEmail
			END) As DeliveryEmail,	
			(CASE
				WHEN ad.PayableTo is null and m.MatterTypeId = 3 THEN 
							(SELECT (case when PayableTo is null or len(PayableTo) = 0 THEN cr.[Name] ELSE 
							 PayableTo END) FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.PayableTo
			END) As PayableTo,	
			(CASE
				WHEN ad.AttentionTo is null and m.MatterTypeId = 3 THEN 
							(SELECT AttentionTo FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.AttentionTo
			END) As AttentionTo,	
			(CASE
				WHEN ad.ContactName is null and m.MatterTypeId = 3 THEN 
							(SELECT ContactName FROM tblSettlements_DeliveryAddresses WHERE SettlementId in 
							(SELECT SettlementId FROM tblSettlements WHERE MatterId = @MatterId)) 
				ELSE ad.ContactName
			END) As ContactName,
			isnull(ad.DeliveryFee, (SELECT DeliveryAmount FROM tblSettlements WHERE MatterId = @MatterId)) As DeliveryFee
	FROM 
		tblAccount_PaymentProcessing acc inner join
		tblMatter m ON m.MatterId = acc.MatterId inner join
		tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId inner join
		tblMatterStatusCode msc ON msc.MatterStatusCodeId = m.MatterStatusCodeId inner join
		tblMatterSubStatus mss ON mss.MatterSubStatusId = m.MatterSubStatusId left join
		tblAccount_DeliveryInfo ad ON ad.MatterId = acc.MatterId left join
		tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId left join
		tblAccount a ON a.AccountId = ci.AccountId left join
		tblCreditor cr ON cr.CreditorId = ci.CreditorId
	WHERE acc.MatterId = @MatterId
	
END
GO


GRANT EXEC ON stp_GetAccountingInformation TO PUBLIC

GO


