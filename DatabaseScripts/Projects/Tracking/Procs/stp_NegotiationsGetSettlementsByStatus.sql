IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsGetSettlementsByStatus')
	BEGIN
		DROP  Procedure  stp_NegotiationsGetSettlementsByStatus
	END

GO

CREATE PROCEDURE [dbo].[stp_NegotiationsGetSettlementsByStatus]
(
	@SettlementStatusID nvarchar(500),
	@UserID int = null
)

as

if @UserID is null
begin
	EXEC
	('
		declare @vtblRoadMaps table
		(
			RoadmapID int,
			SettlementID int
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

		SELECT distinct
			s.SettlementID,
			c.Name AS [Creditor Name],
			p.FirstName + '' '' + p.LastName AS [Client Name],
			s.CreditorAccountBalance,
			s.SettlementAmount,
			s.SettlementPercent,
			s.SettlementSavings,
			s.SettlementDueDate,
			nss.[Name] as SettlementStatus,
			nr.Created as [StatusDate],
			cl.AccountNumber,
			substring(ci.accountnumber,len(ci.accountnumber)-4,4) as CreditorAccountNumber
		FROM         
			@vtblRoadMaps as nr2
			inner join tblNegotiationRoadmap as nr on nr.RoadmapID = nr2.RoadmapID and (nr.SettlementStatusID in (' + @SettlementStatusID + '))
			inner join tblNegotiationSettlementStatus as nss on nss.SettlementStatusID = nr.SettlementStatusID
			inner join tblSettlements as s on s.SettlementID = nr.SettlementID and s.active = 1
			inner join tblClient as cl on s.ClientID = cl.ClientID
			inner join tblPerson as p on p.PersonID = cl.PrimaryPersonID
			inner join tblAccount as a on a.AccountID = s.CreditorAccountID
			inner join tblCreditorInstance as ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID
			inner join tblCreditor as c on c.CreditorID = ci.CreditorID
			inner join tblSettlementProcessing as sp on sp.SettlementID = s.SettlementID
		ORDER BY
			s.SettlementDueDate asc
	')
end
else
begin
	EXEC
	('
		declare @vtblRoadMaps table
		(
			RoadmapID int,
			SettlementID int
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

		SELECT distinct
			s.SettlementID,
			c.Name AS [Creditor Name],
			p.FirstName + '' '' + p.LastName AS [Client Name],
			s.CreditorAccountBalance,
			s.SettlementAmount,
			s.SettlementPercent,
			s.SettlementSavings,
			s.SettlementDueDate,
			nss.[Name] as SettlementStatus,
			nr.Created as [StatusDate],
			cl.AccountNumber,
			substring(ci.accountnumber,len(ci.accountnumber)-4,4) as CreditorAccountNumber
		FROM         
			@vtblRoadMaps as nr2
			inner join tblNegotiationRoadmap as nr on nr.RoadmapID = nr2.RoadmapID and (nr.SettlementStatusID in (' + @SettlementStatusID + '))
			inner join tblNegotiationSettlementStatus as nss on nss.SettlementStatusID = nr.SettlementStatusID
			inner join tblSettlements as s on s.SettlementID = nr.SettlementID and s.active = 1
			inner join tblClient as cl on s.ClientID = cl.ClientID
			inner join tblPerson as p on p.PersonID = cl.PrimaryPersonID
			inner join tblAccount as a on a.AccountID = s.CreditorAccountID
			inner join tblCreditorInstance as ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID
			inner join tblCreditor as c on c.CreditorID = ci.CreditorID
			inner join tblSettlementProcessing as sp on sp.SettlementID = s.SettlementID
		WHERE
			sp.UserID = ' + @UserID + '
		ORDER BY
			s.SettlementDueDate asc
	')
end

GRANT EXEC ON stp_NegotiationsGetSettlementsByStatus TO PUBLIC




