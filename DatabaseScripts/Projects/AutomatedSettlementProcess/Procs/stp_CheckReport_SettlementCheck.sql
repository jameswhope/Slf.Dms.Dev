IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_CheckReport_SettlementCheck')
	BEGIN
		DROP  Procedure  stp_CheckReport_SettlementCheck
	END

GO

CREATE Procedure [dbo].[stp_CheckReport_SettlementCheck]
(
@PaymentId INT 
)
AS BEGIN

	select
ReferenceNumber,CurrentCreditorAcctNo,CurrentCreditorName,[Clientname]= SUBSTRING(ClientName, 0, CHARINDEX(',',[ClientName])), [CoApplicantName]=SUBSTRING(ClientName, CHARINDEX(',',[ClientName])+1, CHARINDEX(',',[ClientName],CHARINDEX(',',[ClientName]))), [ClientSSN] = SUBSTRING(ClientSSN, 0, CHARINDEX(',',ClientSSN)), [CoAppSSN] = SUBSTRING(ClientSSN, CHARINDEX(',',[ClientSSN])+1, CHARINDEX(',',[ClientSSN],CHARINDEX(',',[ClientSSN]))+1), CheckAmount,CheckDate,SettlementAgreementDate,CompanyAddress1,CompanyAddress2,CompanyCity,CompanyState,companyZip,BankDisplayName,Street,City,[State],Zip,RoutingNumber,AccountNumber,CheckNumber,CompanyId
from
(
SELECT  
		isnull(cci.ReferenceNumber, '') AS ReferenceNumber, 
		cci.AccountNumber AS CurrentCreditorAcctNo, 
		(case when sd.PayableTo is null Then cr.[Name] when len(sd.PayableTo) = 0 Then cr.[Name] else sd.PayableTo end) As CurrentCreditorName, 
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
		ct.AccountNumber,
		acc.checknumber,
		c.companyid
	FROM 
		tblSettlements s inner join
		tblMatter m ON m.MatterId = s.MatterId left join
		tblSettlements_DeliveryAddresses sd ON sd.SettlementId = s.SettlementId inner join
		tblAccount_PaymentProcessing acc ON acc.MatterId = s.MatterId inner join 
		tblAccount a ON s.CreditorAccountId = a.AccountId inner join
		tblCreditorInstance cci ON cci.CreditorInstanceId = a.CurrentCreditorInstanceId inner join
		tblCreditor cr ON cr.CreditorId = cci.CreditorId inner join
		tblClient c ON s.ClientId = c.ClientId inner join
		tblCompanyAddresses caddr ON caddr.CompanyId = c.CompanyId and AddressTypeId = 7 inner join
		tblCompany com ON com.CompanyID = c.CompanyId inner join
		tblCompanyTrust ct ON ct.CompanyId = c.CompanyId inner join
		tblState st ON st.StateId = ct.StateId
	WHERE 		acc.PaymentProcessingId = @PaymentId 
		) chkData
	option (fast 100)
END
GO
 

