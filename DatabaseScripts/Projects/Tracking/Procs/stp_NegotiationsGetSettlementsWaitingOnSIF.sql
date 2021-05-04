IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsGetSettlementsWaitingOnSIF')
	BEGIN
		DROP  Procedure  stp_NegotiationsGetSettlementsWaitingOnSIF
	END

GO

create procedure [dbo].[stp_NegotiationsGetSettlementsWaitingOnSIF]
(
	@UserID int
)
as
BEGIN
	declare @vtblRoadMaps table
	(
	roadmapID int,
	settlementID int
	)
	INSERT INTO
		@vtblRoadMaps
	SELECT
		max(RoadmapID) as RoadmapID,
		SettlementID
	FROM
		tblNegotiationRoadmap
	GROUP BY
		SettlementID
		
	SELECT     s.SettlementID, c.Name AS [Creditor Name], p.FirstName + ' ' + p.LastName AS [Client Name], s.CreditorAccountBalance, s.SettlementAmount, 
						  s.SettlementSavings, s.SettlementDueDate,substring(ci.accountnumber,len(ci.accountnumber)-4,4) as accountNumber
	FROM         @vtblRoadMaps AS nr2 INNER JOIN
						  tblNegotiationRoadmap AS nr ON nr.RoadmapID = nr2.RoadmapID INNER JOIN
						  tblNegotiationSettlementStatus AS nss ON nss.SettlementStatusID = nr.SettlementStatusID INNER JOIN
						  tblSettlements AS s ON s.SettlementID = nr.SettlementID INNER JOIN
						  tblPerson AS p ON p.ClientID = s.ClientID INNER JOIN
						  tblAccount AS a ON a.AccountID = s.CreditorAccountID INNER JOIN
						  tblCreditorInstance AS ci ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
						  tblCreditor AS c ON c.CreditorID = ci.CreditorID
	WHERE     (nr.SettlementStatusID IN (5)) AND (p.Relationship = 'Prime') AND (s.CreatedBy = @UserID)
	ORDER BY s.SettlementDueDate ASC
END


GRANT EXEC ON stp_NegotiationsGetSettlementsWaitingOnSIF TO PUBLIC

