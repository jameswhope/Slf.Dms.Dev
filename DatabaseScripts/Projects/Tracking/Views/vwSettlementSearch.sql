IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwSettlementSearch')
	BEGIN
		DROP  View vwSettlementSearch
	END
GO

CREATE view [vwSettlementSearch]
as
SELECT     
	s.SettlementID
	, s.CreditorAccountID AS LexxCreditorAccountID
	, s.ClientID AS LexxClientID
	, tblClient.AccountNumber AS LexxAcctNum
	, tblCreditor.Name AS [Creditor Name]
	, tblCreditor.CreditorID AS LexxCreditorID
	, ci.AccountNumber AS CreditAcctNum
	, ci.ReferenceNumber AS CreditorRefNum
	, tblPerson.FirstName + ' ' + tblPerson.LastName AS [Client Name]
	, s.CreditorAccountBalance
	, s.SettlementAmount
	, s.SettlementSavings
	, s.SettlementPercent
	, s.SettlementDueDate
	,s.CreatedBy
	,tblNegotiationRoadmap.SettlementStatusID
FROM tblCreditor 
	INNER JOIN tblCreditorInstance as ci ON tblCreditor.CreditorID = ci.CreditorID 
	INNER JOIN tblSettlements AS s INNER JOIN tblNegotiationRoadmap ON s.SettlementID = tblNegotiationRoadmap.SettlementID 
	INNER JOIN tblNegotiationSettlementStatus ON tblNegotiationRoadmap.SettlementStatusID = tblNegotiationSettlementStatus.SettlementStatusID 
	INNER JOIN tblPerson ON s.ClientID = tblPerson.ClientID 
	INNER JOIN tblAccount ON s.CreditorAccountID = tblAccount.AccountID ON ci.CreditorInstanceID = tblAccount.CurrentCreditorInstanceID 
	INNER JOIN tblClient ON s.ClientID = tblClient.ClientID
WHERE     
	(tblPerson.Relationship = 'Prime')


