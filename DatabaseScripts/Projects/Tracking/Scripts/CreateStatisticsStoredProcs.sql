 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSettlementRankingByPercent')
	BEGIN
		DROP  Procedure  stp_NegotiationSettlementRankingByPercent
	END

GO
 CREATE procedure [dbo].[stp_NegotiationSettlementRankingByPercent]
as
SELECT top(5) 
	RANK() OVER(ORDER BY settlementpercent desc) AS 'Ranking' 
	, u.firstname + ' ' + u.lastname as [Negotiator]
	, max(settlementpercent) as [Settlement %]
FROM vwSettlementSearch as ss INNER JOIN tblUser as u on ss.createdby = u.userid
WHERE ss.settlementstatusid >= 3 
GROUP BY u.firstname, u.lastname,ss.settlementpercent
go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSettlementRankingByNumber')
	BEGIN
		DROP  Procedure  stp_NegotiationSettlementRankingByNumber
	END

GO
CREATE procedure [dbo].[stp_NegotiationSettlementRankingByNumber]
as
SELECT top(5) 
	RANK() OVER(ORDER BY count(*) desc) AS 'Ranking' 
	, u.firstname + ' ' + u.lastname as [Negotiator]
	, count(*) as [Number Of Settlements] 
FROM vwSettlementSearch as ss INNER JOIN tblUser as u on ss.createdby = u.userid
WHERE ss.settlementstatusid >= 3 
GROUP BY u.firstname, u.lastname
go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationSettlementRankingByAmount')
	BEGIN
		DROP  Procedure  stp_NegotiationSettlementRankingByAmount
	END

GO
CREATE procedure [dbo].[stp_NegotiationSettlementRankingByAmount]
as
SELECT top(5) 
	RANK() OVER(ORDER BY ss.settlementamount desc) AS 'Ranking' 	
	, u.firstname + ' ' + u.lastname as [Negotiator]
	, '$' + CONVERT(varchar(10), CONVERT(money,max(ss.settlementamount))) as [Settlement Amount]
FROM vwSettlementSearch as ss INNER JOIN tblUser as u on ss.createdby = u.userid
WHERE ss.settlementstatusid >= 3 
GROUP BY u.firstname, u.lastname,ss.createdby,ss.settlementamount
go
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsProcessingStatistics')
	BEGIN
		DROP  Procedure  stp_NegotiationsProcessingStatistics
	END
GO
CREATE Procedure [dbo].[stp_NegotiationsProcessingStatistics]
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


SELECT     
	u.userid,
	u.FirstName + ' ' + u.LastName AS Employee
	, sum(case when nr.SettlementStatusID = 6  then 1 else 0 end) as [Pending]
	, sum(case when nr.SettlementStatusID = 8 and month(nr.created) = month(getdate()) then 1 else 0 end) as [Verified - Current Month]
	, sum(case when nr.SettlementStatusID = 10 and month(nr.created) = month(getdate()) then 1 else 0 end) as [Approved - Current Month]
	, sum(case when nr.SettlementStatusID = 8 and month(nr.created) = month(dateadd(month,-1,getdate())) then 1 else 0 end) as [Verified - Last Month]
	, sum(case when nr.SettlementStatusID = 10 and month(nr.created) = month(dateadd(month,-1,getdate())) then 1 else 0 end) as [Approved - Last Month]
FROM
    tblSettlementProcessing AS sp INNER JOIN
	tblNegotiationRoadmap AS nr ON sp.SettlementID = nr.SettlementID INNER JOIN
	tblUser AS u ON sp.UserID = u.UserID INNER JOIN
	tblNegotiationSettlementStatus ON nr.SettlementStatusID = tblNegotiationSettlementStatus.SettlementStatusID
	and nr.SettlementStatusID in (6,8,10)
	inner join @vtblRoadMaps as nr2 on nr.RoadmapID = nr2.RoadmapID 
GROUP BY 
	u.userid
	, u.FirstName
	, u.LastName
ORDER BY 
	u.userid
	, u.FirstName
	, u.LastName
END






