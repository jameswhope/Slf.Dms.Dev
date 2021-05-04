IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetSettlementAcceptanceFormData')
	BEGIN
		DROP  Procedure  stp_GetSettlementAcceptanceFormData
	END

GO

CREATE procedure [dbo].[stp_GetSettlementAcceptanceFormData]
(
@SettlementID as int
)
as
BEGIN
SELECT top(1)    
		tblSettlements.SettlementID
, a.AccountID
, tblPerson.FirstName + ' ' + tblPerson.LastName AS ApplicantFullName
, tblClient.AccountNumber AS ControlNum
, tblCompany.ShortCoName AS Firm
, tblAgency.Name AS Agent
, ISNULL(forCred.Name, '') AS OriginalCreditor
, CONVERT(varchar, ci.AccountNumber) AS CAN
, curCred.Name AS CurrentCreditor
, ci.ReferenceNumber AS RefNum
, tblSettlements.SettlementSavings AS ClientSavings
, a.CurrentAmount AS OutstandingBalance
, tblSettlements.SettlementAmount
, tblSettlements.SettlementFee AS SettlementFees
, tblSettlements.SettlementDueDate
, ISNULL(cont.FirstName, '') + ' ' + ISNULL(cont.LastName, '') AS CurrentContact
, tblClient.SDABalance
, tblPhone.AreaCode, tblPhone.Number, tblPhone.Extension, 
ISNULL(vd.NextDepositDate, '1/1/1900') AS NextDepositDate, ISNULL(vd.NextDepositAmount, 0) AS NextDepositAmount, 
tblClient.SettlementFeePercentage AS SettlementFee, tblUser.FirstName + ' ' + tblUser.LastName AS NegotiatedBy
	FROM         tblClient INNER JOIN
						  tblAccount AS a INNER JOIN
						  tblPerson ON a.ClientID = tblPerson.ClientID INNER JOIN
						  tblCreditorInstance AS ci ON a.CurrentCreditorInstanceID = ci.CreditorInstanceID INNER JOIN
						  tblCreditor AS curCred ON ci.CreditorID = curCred.CreditorID ON tblClient.ClientID = a.ClientID INNER JOIN
						  tblAgency ON tblClient.AgencyID = tblAgency.AgencyID INNER JOIN
						  tblCompany ON tblClient.CompanyID = tblCompany.CompanyID LEFT OUTER JOIN
						  vwClientNextDepositSchedule AS vd ON tblClient.ClientID = vd.ClientId LEFT OUTER JOIN
						  tblContactPhone AS cp INNER JOIN
						  tblPhone ON cp.PhoneID = tblPhone.PhoneID RIGHT OUTER JOIN
						  tblContact AS cont ON cp.ContactID = cont.ContactID ON curCred.CreditorID = cont.CreditorID LEFT OUTER JOIN
						  tblCreditor AS forCred ON ci.ForCreditorID = forCred.CreditorID LEFT OUTER JOIN
						  tblUser INNER JOIN
						  tblSettlements ON tblUser.UserID = tblSettlements.CreatedBy ON a.AccountID = tblSettlements.CreditorAccountID
	WHERE     (tblSettlements.SettlementID = @SettlementID) AND (tblPerson.Relationship = 'Prime')
	Order By cont.created desc
END


GO


GRANT EXEC ON stp_GetSettlementAcceptanceFormData TO PUBLIC

GO


