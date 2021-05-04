IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetPaymentsToApproveNonXML')
	BEGIN
		DROP  Procedure  stp_GetPaymentsToApproveNonXML
	END

GO

CREATE Procedure stp_GetPaymentsToApproveNonXML
(
@CompanyXml varchar(500) = null,
@RequestType varchar(500) = null,
@DelMethod varchar(500) = null,
@ToDate DATETIME = null,
@FromDate DATETIME = null
)
AS 
BEGIN
	SET ARITHABORT ON;
	declare @ssql varchar(max)
	
	IF @FromDate is null BEGIN
		SELECT @FromDate = min(DueDate) FROM tblAccount_PaymentProcessing WHERE ApprovedDate is null
	END
	IF @ToDate is null BEGIN
		SELECT @ToDate = max(DueDate) FROM tblAccount_PaymentProcessing WHERE ApprovedDate is null
	END
	IF @CompanyXml is null BEGIN
		--SET @CompanyXml = (SELECT CompanyId "@id" FROM tblCompany FOR XML PATH('Company'))
		set @CompanyXml = (SELECT cast(CompanyId as varchar) + ',' FROM tblCompany FOR XML PATH(''))
		set @CompanyXml = left(@CompanyXml,len(@CompanyXml)-1)
	END
	IF @RequestType is null BEGIN
		--SET @RequestType = (SELECT DISTINCT RequestType "@type" FROM tblAccount_PaymentProcessing FOR XML PATH('RequestType'))
		set @RequestType = (SELECT DISTINCT cast(RequestType as varchar) +  char(39) + ',' + char(39) FROM tblAccount_PaymentProcessing FOR XML PATH(''))
		set @RequestType = char(39) + left(@RequestType,len(@RequestType)-2)
	END
	IF @DelMethod is null BEGIN
		--SET @DelMethod = (SELECT DISTINCT DeliveryMethod "@del" FROM tblAccount_PaymentProcessing FOR XML PATH('DeliveryMethod'))
		set @DelMethod = (SELECT DISTINCT cast(DeliveryMethod as varchar) + char(39) + ',' + char(39) FROM tblAccount_PaymentProcessing FOR XML PATH(''))
		set @DelMethod = char(39) + left(@DelMethod,len(@DelMethod)-2)
	END

	set @ssql = 'SELECT acc.PaymentProcessingId,m.MatterId,acc.CheckAmount AS CheckAmount,acc.DueDate,acc.RequestType,c.ClientId,c.AccountNumber,'
	set @ssql = @ssql + 'ci.AccountId,''***'' + right(ci.AccountNumber,4) [Last4],p.FirstName + '' '' + p.LastName AS ClientName,com.[ShortCoName] AS Firm,'
	set @ssql = @ssql + 'cr.[Name] AS CreditorName,c.AvailableSDA - dbo.udf_FundsOnHold(s.ClientID,s.SettlementID) [AvailableSDA],acc.deliverymethod,'
	set @ssql = @ssql + '(SELECT count(*) FROM tblRegister r WHERE r.ClientId= c.ClientId and (TransactionDate between dateadd(mm,-6,getdate()) and getdate()) and bounce is not null ) AS Bounce,'
	set @ssql = @ssql + '(case when d.PayableTo is null Then cr.[Name] when len(d.PayableTo) = 0 Then cr.[Name] else d.PayableTo end) As [PayableTo],'
	set @ssql = @ssql + 'acc.IsPreApproved,s.SettlementID '
	set @ssql = @ssql + 'FROM tblAccount_PaymentProcessing acc inner join tblMatter m ON m.MatterId = acc.MatterId inner join '
	set @ssql = @ssql + 'tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 inner join '
	set @ssql = @ssql + 'tblClient c ON c.ClientId = m.ClientId inner join tblPerson p ON p.Personid = c.PrimaryPersonId inner join '
	set @ssql = @ssql + 'tblCompany com ON c.CompanyId = com.CompanyId and com.CompanyId in (' + @CompanyXml + ') inner join '
	set @ssql = @ssql + 'tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join '
	set @ssql = @ssql + 'tblCreditor cr ON cr.CreditorId = ci.CreditorId inner join tblSettlements s on s.matterid = m.matterid left join '
	set @ssql = @ssql + 'tblSettlements_DeliveryAddresses d on d.settlementid = s.settlementid '
	set @ssql = @ssql + 'WHERE acc.isApproved is null and acc.Processed = 0 and acc.DueDate between ' + char(39) + cast(@FromDate as varchar) + char(39) + ' and ' + char(39) + cast(@ToDate as varchar) + char(39) 
	set @ssql = @ssql + 'and acc.RequestType in (' + @RequestType + ') '
	set @ssql = @ssql + 'and acc.DeliveryMethod in (' + @DelMethod + ') '
	set @ssql = @ssql + 'ORDER BY [DueDate], [ClientName] '

	exec (@ssql)

END
GO


GRANT EXEC ON stp_GetPaymentsToApproveNonXML TO PUBLIC

GO


