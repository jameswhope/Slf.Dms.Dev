IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckReport_SettlementCheck')
	BEGIN
		DROP  Procedure  stp_CheckReport_SettlementCheck
	END

GO

CREATE Procedure stp_CheckReport_SettlementCheck
(
@MatterId INT 
)
AS BEGIN

	select
ReferenceNumber,CurrentCreditorAcctNo,CurrentCreditorName,[Clientname]= SUBSTRING(ClientName, 0, CHARINDEX(',',[ClientName])), [CoApplicantName]=SUBSTRING(ClientName, CHARINDEX(',',[ClientName])+1, CHARINDEX(',',[ClientName],CHARINDEX(',',[ClientName]))), [ClientSSN] = SUBSTRING(ClientSSN, 0, CHARINDEX(',',ClientSSN)), [CoAppSSN] = SUBSTRING(ClientSSN, CHARINDEX(',',[ClientSSN])+1, CHARINDEX(',',[ClientSSN],CHARINDEX(',',[ClientSSN]))+1), CheckAmount,CheckDate,SettlementAgreementDate,CompanyAddress1,CompanyAddress2,CompanyCity,CompanyState,companyZip,BankDisplayName,Street,City,[State],Zip,RoutingNumber,AccountNumber
from
(
SELECT  
		isnull(cci.ReferenceNumber, '') AS ReferenceNumber, 
		cci.AccountNumber AS CurrentCreditorAcctNo, 
		(case when ad.PayableTo is null and m.MatterTypeId = 3 THEN (case when sd.PayableTo is null or len(sd.PayableTo) = 0 Then cr.[Name] else sd.PayableTo end)
			else ad.PayableTo end) As CurrentCreditorName,
		[Clientname] =(select p.FirstName + ' ' +p.LastName + ', '  from tblPerson	p where p.clientid= c.clientid Order By p.PersonId FOR XML PATH('')) ,
		[ClientSSN] =(select p.SSN + ', '  from tblPerson	p where p.clientid= c.clientid Order By p.PersonId FOR XML PATH('')) ,
		acc.CheckAmount,
		isnull( acc.ProcessedDate, getdate()) AS CheckDate,
		m.CreatedDateTime AS SettlementAgreementDate,		
		caddr.Address1 AS CompanyAddress1,
		caddr.Address2 AS CompanyAddress2,
		caddr.City AS CompanyCity,
		caddr.State AS CompanyState,
		caddr.ZipCode AS companyZip,
		ct.BankDisplayName,
		ct.Street,
		ct.City,
		st.Abbreviation AS [State],
		ct.Zip,
		ct.RoutingNumber,
		ct.AccountNumber 
	FROM 		
		tblMatter m inner join
		tblAccount_PaymentProcessing acc ON acc.MatterId = m.MatterId inner join
		tblClient c ON c.ClientId = m.ClientId  inner join
		tblCompanyAddresses caddr ON caddr.CompanyId = c.CompanyId and caddr.AddressTypeId = 7 inner join
		tblCompany com ON com.CompanyID = c.CompanyId inner join
		tblCompanyTrust ct ON ct.CompanyId = c.CompanyId inner join
		tblState st ON st.StateId = ct.StateId left join	
		tblAccount_DeliveryInfo ad ON ad.MatterId = m.MatterId left join	
		tblCreditorInstance cci ON cci.CreditorInstanceId = m.CreditorInstanceId left join
		tblCreditor cr ON cr.CreditorId = cci.CreditorId left join
		tblAccount a ON a.AccountId = cci.AccountId left join
		tblSettlements s ON s.MatterId = m.MatterId left join
		tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId
	WHERE 		m.MatterId = @MatterId 
		) chkData
	option (fast 100)
END
GO



