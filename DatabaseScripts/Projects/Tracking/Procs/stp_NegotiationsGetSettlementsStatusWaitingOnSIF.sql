IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsGetSettlementsStatusWaitingOnSIF')
	BEGIN
		DROP  Procedure  stp_NegotiationsGetSettlementsStatusWaitingOnSIF
	END

GO

CREATE procedure [dbo].[stp_NegotiationsGetSettlementsStatusWaitingOnSIF]
(
	@UserID int
)
as
BEGIN
	
	SELECT     s.SettlementID, c.Name AS [Creditor Name], p.FirstName + ' ' + p.LastName AS [Client Name], s.CreditorAccountBalance, s.SettlementAmount, 
						  s.SettlementSavings, s.SettlementDueDate,substring(ci.accountnumber,len(ci.accountnumber)-4,4) as accountNumber
	FROM         (
			SELECT     SettlementID
			FROM         dbo.tblNegotiationRoadmap
			GROUP BY SettlementID
			having MAX(SettlementStatusID) = 5
	) AS nr2 INNER JOIN
						  tblSettlements AS s with(nolock) ON s.SettlementID = nr2.SettlementID and s.active = 1 INNER JOIN
						  tblPerson AS p with(nolock) ON p.ClientID = s.ClientID INNER JOIN
						  tblAccount AS a with(nolock) ON a.AccountID = s.CreditorAccountID INNER JOIN
						  tblCreditorInstance AS ci with(nolock) ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
						  tblCreditor AS c with(nolock) ON c.CreditorID = ci.CreditorID
	WHERE     (p.Relationship = 'Prime') AND (s.CreatedBy = @UserID)
	ORDER BY s.SettlementDueDate ASC
	option (fast 50)	
END


GRANT EXEC ON stp_NegotiationsGetSettlementsStatusWaitingOnSIF TO PUBLIC