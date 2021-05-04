IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSettlementRankingByPercent')
	BEGIN
		DROP  Procedure  stp_NegotiationSettlementRankingByPercent
	END

GO

CREATE Procedure stp_NegotiationSettlementRankingByPercent

AS
SELECT top(5) 
	RANK() OVER(ORDER BY settlementpercent desc) AS 'Ranking' 
	, u.firstname + ' ' + u.lastname as [Negotiator]
	, max(settlementpercent) as [Settlement %]
FROM vwSettlementSearch as ss INNER JOIN tblUser as u on ss.createdby = u.userid
WHERE ss.settlementstatusid >= 3 
group by ss.SettlementPercent,u.firstname + ' ' + u.lastname

GO


GRANT EXEC ON stp_NegotiationSettlementRankingByPercent TO PUBLIC

GO


