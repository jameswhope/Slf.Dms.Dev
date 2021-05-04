IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Negotiations_Get_AttachSIFData')
	BEGIN
		DROP  Procedure  stp_Negotiations_Get_AttachSIFData
	END

GO
create procedure stp_Negotiations_Get_AttachSIFData
(
	@settlementID numeric
)
as
BEGIN
   SELECT  TOP 1   
		s.SettlementID
		, s.ClientID
		, s.CreditorAccountID
		, cl.AccountNumber AS ClientAccountNumber
		, c.Name AS [Creditor Name]
		, oc.Name AS [Original Creditor Name]
		, c.CreditorID
		, [Client Name]=(select top 1 p.FirstName + ' ' + p.LastName from tblperson p where p.personid = cl.primarypersonid and p.relationship = 'prime')
		, [Co Client Name]=(select top 1 p.FirstName + ' ' + p.LastName from tblperson p where p.clientid = cl.clientid and not p.relationship = 'prime')
		, s.CreditorAccountBalance
		, s.SettlementAmount
		, s.SettlementSavings
		, s.SettlementDueDate
		, SUBSTRING(ci.AccountNumber, LEN(ci.AccountNumber) - 4, 4) AS CreditorAccountNumber
		, ci.AccountNumber AS CreditorAccountNumberFull
		, ci.ReferenceNumber AS CreditorReferenceNumber
		, isnull(s.IsPaymentArrangement,0) as IsPaymentArrangement
	FROM         
		tblNegotiationRoadmap AS nr with(nolock) INNER JOIN
		tblNegotiationSettlementStatus AS nss with(nolock) ON nss.SettlementStatusID = nr.SettlementStatusID INNER JOIN
		tblSettlements AS s with(nolock) ON s.SettlementID = nr.SettlementID INNER JOIN
		tblAccount AS a with(nolock) ON a.AccountID = s.CreditorAccountID INNER JOIN
		tblCreditorInstance AS ci with(nolock) ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
		tblCreditor AS c with(nolock) ON c.CreditorID = ci.CreditorID INNER JOIN
		tblClient AS cl with(nolock) ON s.ClientID = cl.ClientID inner join
		tblCreditorInstance AS oci with(nolock) ON oci.CreditorInstanceID = a.originalCreditorInstanceID INNER JOIN
		tblCreditor AS oc with(nolock) ON oc.CreditorID = oci.CreditorID 
	WHERE     
		(s.SettlementID = @settlementID)
END