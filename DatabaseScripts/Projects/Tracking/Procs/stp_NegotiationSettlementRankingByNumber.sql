IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSettlementRankingByNumber')
	BEGIN
		DROP  Procedure  stp_NegotiationSettlementRankingByNumber
	END

GO

CREATE Procedure stp_NegotiationSettlementRankingByNumber
AS
SELECT top(5) 
	RANK() OVER(ORDER BY count(*) desc) AS 'Ranking' 
	, u.firstname + ' ' + u.lastname as [Negotiator]
	, count(*) as [Number Of Settlements] 
FROM vwSettlementSearch as ss INNER JOIN tblUser as u on ss.createdby = u.userid
WHERE ss.settlementstatusid >= 3 
GROUP BY u.firstname, u.lastname

GO


GRANT EXEC ON stp_NegotiationSettlementRankingByNumber TO PUBLIC



