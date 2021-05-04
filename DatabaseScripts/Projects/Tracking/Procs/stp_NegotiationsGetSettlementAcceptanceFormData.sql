IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsGetSettlementAcceptanceFormData')
	BEGIN
		DROP  Procedure  stp_NegotiationsGetSettlementAcceptanceFormData
	END

GO

create procedure [dbo].[stp_NegotiationsGetSettlementAcceptanceFormData]
(
	@SettlementID as int
)
as
BEGIN
SELECT     TOP (1) 
s.CreditorAccountID
, s.ClientID
, p.FirstName
, p.LastName
, p.Street
, p.Street2
, p.City
, tblState.Abbreviation
, p.ZipCode
, tblClient.AccountNumber
, tblUser.FirstName + ' ' + tblUser.LastName AS Mediator
, tblAgency.Name AS Agency
, origcred.Name AS OriginalCreditor
, currcred.Name AS CurrentCreditor
, tblCreditorInstance_1.AccountNumber AS CreditorAcctNum
, tblCreditorInstance.ReferenceNumber
, isnull(s.SettlementDueDate,'') as SettlementDueDate
, tblAccount.CurrentAmount
, s.SettlementAmount
, isnull(s.SettlementAmtAvailable,'0.00') as [SettlementAmtAvailable]
, isnull(s.SettlementAmtBeingSent,'0.00') as [SettlementAmtBeingSent]
, isnull(s.SettlementAmtStillOwed,'0.00') as [SettlementAmtStillOwed]
, isnull(s.SettlementSavings,'0.00') as [SettlementSavings]
, isnull(s.SettlementFee,'0.00') as [SettlementFee]
, isnull(s.SettlementCost,'0.00') as [SettlementCost]
, isnull(s.OvernightDeliveryAmount,'0.00') as [OvernightDeliveryAmount]
, isnull(tblAccount.SettlementFeeCredit,'0.00') as [SettlementFeeCredit]
, isnull(s.SettlementFeeAmtAvailable,'0.00') as [SettlementFeeAmtAvailable]
, isnull(s.SettlementFeeAmtBeingPaid,'0.00') as [SettlementFeeAmtBeingPaid]
, isnull(s.SettlementFeeAmtStillOwed,'0.00') as [SettlementFeeAmtStillOwed]
,tblCreditorInstance.CreditorInstanceID
FROM         tblCreditor AS origcred INNER JOIN
                      tblCreditorInstance AS tblCreditorInstance_1 ON origcred.CreditorID = tblCreditorInstance_1.CreditorID RIGHT OUTER JOIN
                      tblCreditor AS currcred INNER JOIN
                      tblCreditorInstance ON currcred.CreditorID = tblCreditorInstance.CreditorID INNER JOIN
                      tblSettlements AS s INNER JOIN
                      tblClient ON s.ClientID = tblClient.ClientID INNER JOIN
                      tblPerson AS p ON tblClient.ClientID = p.ClientID LEFT JOIN
                      tblState ON p.StateID = tblState.StateID INNER JOIN
                      tblUser ON s.CreatedBy = tblUser.UserID INNER JOIN
                      tblAgency ON tblClient.AgencyID = tblAgency.AgencyID INNER JOIN
                      tblAccount ON s.CreditorAccountID = tblAccount.AccountID ON tblCreditorInstance.CreditorInstanceID = tblAccount.CurrentCreditorInstanceID ON 
                      tblCreditorInstance_1.CreditorInstanceID = tblAccount.OriginalCreditorInstanceID
WHERE     (s.SettlementID = @SettlementID)
	ORDER BY tblCreditorInstance.Created DESC
END


GO


GRANT EXEC ON stp_NegotiationsGetSettlementAcceptanceFormData TO PUBLIC

GO


