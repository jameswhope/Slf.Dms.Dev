IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSettlementRankingByAmount')
	BEGIN
		DROP  Procedure  stp_NegotiationSettlementRankingByAmount
	END
GO

CREATE procedure stp_NegotiationSettlementRankingByAmount
as
SELECT top(5) 
	RANK() OVER(ORDER BY ss.settlementamount desc) AS 'Ranking' 	
	, u.firstname + ' ' + u.lastname as [Negotiator]
	, '$' + CONVERT(varchar(10), CONVERT(money,max(ss.settlementamount))) as [Settlement Amount]
FROM vwSettlementSearch as ss INNER JOIN tblUser as u on ss.createdby = u.userid
WHERE ss.settlementstatusid >= 3 
GROUP BY u.firstname, u.lastname,ss.createdby,ss.settlementamount 


