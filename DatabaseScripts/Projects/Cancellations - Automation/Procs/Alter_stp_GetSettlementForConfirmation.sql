IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementForConfirmation')
	BEGIN
		DROP  Procedure  stp_GetSettlementForConfirmation
	END

GO

CREATE Procedure stp_GetSettlementForConfirmation
(
	@DeliveryAddress varchar(300) = null
)
AS
BEGIN

	SELECT
		acc.MatterId,
		acc.CheckAmount AS Amount,
		acc.DueDate AS DueDate,
		acc.RequestType,
		c.ClientId,
		ci.AccountId AS AccountId,	
		p.FirstName + ' ' + p.LastName AS ClientName,
		com.[ShortCoName] AS Firm,
		cr.[Name] AS CreditorName,
		'Check' [DeliveryMethod],
		(case 
			when ad.AttentionTo is null and m.MatterTypeId = 3 THEN isnull(sd.AttentionTo,'')
			else ad.AttentionTo 
		end) AS AttentionTo,
		(case
			when ad.MatterId is null and m.MatterTypeId = 3 then (isnull(sd.Address,'') + ', ' + isnull(sd.City,'') + ' ' + isnull(sd.State,'') + ' ' + isnull(sd.zip,''))
			else isnull(ad.DeliveryAddress,'') + ', ' + isnull(ad.DeliveryCity,'') + ' ' + isnull(ad.DeliveryState,'') + ' ' + isnull(ad.Deliveryzip,'')
		end) AS DeliveryAddress
	into 
		#temp
	FROM
		tblAccount_PaymentProcessing acc inner join
		tblMatter m ON m.MatterId = acc.MatterId inner join
		tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join
		tblClient c ON c.ClientId = m.ClientId inner join
		tblPerson p ON p.Personid = c.PrimaryPersonId inner join
		tblCompany com ON c.CompanyId = com.CompanyId left join
		tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId left join
		tblCreditor cr ON cr.CreditorId = ci.CreditorId left join 
		tblAccount_DeliveryInfo ad ON ad.MatterId = acc.MatterId left join
		tblSettlements s ON s.MatterId = acc.MatterId left join
		tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId
	WHERE
		acc.DeliveryMethod = 'C' 
		and acc.IsCheckPrinted = 1 
		and acc.Processed = 0 
		and acc.IsApproved = 1
		
	select *
	from #temp
	where (@DeliveryAddress is null or DeliveryAddress = @DeliveryAddress)
	order by DeliveryAddress
	
	select distinct DeliveryAddress
	from #temp 
	where (@DeliveryAddress is null or DeliveryAddress = @DeliveryAddress)
	order by DeliveryAddress
	
	drop table #temp
	
END
GO

