IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementChecksToPrint')
	BEGIN
		DROP  Procedure  stp_GetSettlementChecksToPrint
	END

GO

CREATE Procedure [dbo].[stp_GetSettlementChecksToPrint]
(
	@DeliveryAddress varchar(300) = null
)
AS
BEGIN

SELECT
	acc.MatterId,
	acc.PaymentProcessingId,
	acc.CheckAmount AS CheckAmount,
	c.ClientId,
	ci.AccountId AS AccountId,
	p.FirstName + ' ' + p.LastName AS ClientName,
	com.[ShortCoName] AS Firm,
	cr.[Name] AS CreditorName,
	c.AvailableSDA - dbo.udf_FundsOnHold(s.ClientID,s.SettlementID) [AvailableSDA],
	acc.DueDate,
	isnull(da.AttentionTo,'') [AttentionTo],
	isnull(da.Address,'') + ', ' + isnull(da.City,'') + ' ' + isnull(da.State,'') + ' ' + isnull(da.zip,'') [DeliveryAddress]
into 
	#temp
FROM
	tblAccount_PaymentProcessing acc inner join
	tblMatter m ON m.MatterId = acc.MatterId inner join
	tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join
	tblClient c ON c.ClientId = m.ClientId inner join
	tblPerson p ON p.Personid = c.PrimaryPersonId inner join
	tblCompany com ON c.CompanyId = com.CompanyId inner join
	tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join
	tblCreditor cr ON cr.CreditorId = ci.CreditorId left join
	tblSettlements s ON s.MatterId = m.MatterId left join
	tblSettlements_DeliveryAddresses da ON da.SettlementId = s.SettlementId 
WHERE
	acc.DeliveryMethod = 'C' 
	and acc.Processed = 0 
	and acc.IsCheckPrinted = 0 
	and acc.IsApproved = 1
	
	
select *
from #temp
where (@DeliveryAddress is null or DeliveryAddress = @DeliveryAddress)
order by DueDate

select distinct DeliveryAddress
from #temp 
where (@DeliveryAddress is null or DeliveryAddress = @DeliveryAddress)
order by DeliveryAddress

drop table #temp	

	
END
GO