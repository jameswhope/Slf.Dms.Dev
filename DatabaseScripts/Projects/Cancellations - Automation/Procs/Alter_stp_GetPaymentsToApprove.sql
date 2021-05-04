﻿IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPaymentsToApprove')
	BEGIN
		DROP  Procedure  stp_GetPaymentsToApprove
	END

GO

CREATE Procedure [dbo].[stp_GetPaymentsToApprove]
(
@CompanyXml XML = null,
@RequestType XML = null,
@DelMethod XML = null,
@ToDate DATETIME = null,
@FromDate DATETIME = null,
@IsPreApproved INT = 0
)
AS BEGIN
SET ARITHABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;

IF @FromDate is null BEGIN
	SELECT @FromDate = min(DueDate) FROM tblAccount_PaymentProcessing WHERE ApprovedDate is null
END
IF @ToDate is null BEGIN
	SELECT @ToDate = max(DueDate) FROM tblAccount_PaymentProcessing WHERE ApprovedDate is null
END
IF @CompanyXml is null BEGIN
	SET @CompanyXml = (SELECT CompanyId "@id" FROM tblCompany FOR XML PATH('Company'))
END
IF @RequestType is null BEGIN
	SET @RequestType = (SELECT DISTINCT RequestType "@type" FROM tblAccount_PaymentProcessing FOR XML PATH('RequestType'))
END
IF @DelMethod is null BEGIN
	SET @DelMethod = (SELECT DISTINCT DeliveryMethod "@del" FROM tblAccount_PaymentProcessing FOR XML PATH('DeliveryMethod'))
END

SELECT
	acc.PaymentProcessingId,
	m.MatterId,
	acc.CheckAmount AS CheckAmount,
	acc.DueDate,
	acc.RequestType,
	c.ClientId,
	c.AccountNumber,
	ci.AccountId,
	'***' + right(ci.AccountNumber,4) [Last4],
	p.FirstName + ' ' + p.LastName AS ClientName,
	com.[ShortCoName] AS Firm,
	cr.[Name] AS CreditorName,
	c.AvailableSDA - dbo.udf_FundsOnHold(m.ClientID,isnull(s.SettlementID,0)) [AvailableSDA],
	acc.deliverymethod,
	(SELECT count(*) FROM tblRegister r WHERE r.ClientId= c.ClientId and (TransactionDate between dateadd(mm,-6,getdate()) and getdate()) and bounce is not null ) AS Bounce,
	isnull(ad.PayableTo, (case when sd.PayableTo is null or len(sd.PayableTo) = 0 Then cr.[Name] else sd.PayableTo end)) As PayableTo
FROM
	tblAccount_PaymentProcessing acc inner join
	tblMatter m ON m.MatterId = acc.MatterId inner join
	tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join
	tblClient c ON c.ClientId = m.ClientId inner join
	tblPerson p ON p.Personid = c.PrimaryPersonId inner join
	tblCompany com ON c.CompanyId = com.CompanyId and com.CompanyId in (SELECT ParamValues.ParamId.value('@id','int') 
				FROM @CompanyXml.nodes('/Company') AS ParamValues(ParamId)) left join
	tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId left join
	tblCreditor cr ON cr.CreditorId = ci.CreditorId left join 
	tblAccount_DeliveryInfo ad ON ad.MatterId = acc.MatterId left join
	tblSettlements s ON s.MatterId = acc.MatterId left join
	tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId
WHERE
	acc.isApproved is null 
	and acc.Processed = 0 
	and acc.IsPreApproved = @IsPreApproved
	and acc.DueDate between @FromDate and @ToDate
	and acc.RequestType in (SELECT ParamValues.ParamId.value('@type','varchar(20)') 
				FROM @RequestType.nodes('/RequestType') AS ParamValues(ParamId))
	and acc.DeliveryMethod in (SELECT ParamValues.ParamId.value('@del','varchar(4)') 
				FROM @DelMethod.nodes('/DeliveryMethod') AS ParamValues(ParamId))
ORDER BY 
	[DueDate], [ClientName]

SET ARITHABORT OFF;
END	
GO



