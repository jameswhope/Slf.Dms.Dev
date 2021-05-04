IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsProcessingStatistics')
	BEGIN
		DROP  Procedure  stp_NegotiationsProcessingStatistics
	END

GO

CREATE Procedure stp_NegotiationsProcessingStatistics
as
BEGIN

declare @vtblRoadMaps table
(
	roadmapID int,
	settlementID int
)

declare @temp table
(
	UserID int,
	ProcessedCurrentMonth int,
	ProcessedLastMonth int
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


insert into
	@temp
select
	sp.UserID
,	sum(case when nr.SettlementStatusID = 10 and month(nr.created) = month(getdate()) then 1 else 0 end) [ProcessedCurrentMonth]
,	sum(case when nr.SettlementStatusID = 10 and month(nr.created) = month(dateadd(month,-1,getdate())) then 1 else 0 end) [ProcessedLastMonth]
from 
	tblNegotiationRoadmap nr
join 
	tblSettlementProcessing sp on sp.SettlementID = nr.SettlementID
where 
	nr.SettlementStatusID in (10)
group by 
	sp.Userid


SELECT
	  u.UserID
	, u.FirstName + ' ' + u.LastName [Employee]
	, sum(case when nr.SettlementStatusID = 6  then 1 else 0 end) [TotalPendingVerification]
	, sum(case when nr.SettlementStatusID = 8  then 1 else 0 end) [TotalPendingClientApproval]
	, sum(case when nr.SettlementStatusID in (6,8)  then 1 else 0 end) [TotalPending]
	, isnull(t.ProcessedCurrentMonth,0) [ProcessedCurrentMonth]
	, isnull(t.ProcessedLastMonth,0) [ProcessedLastMonth]
FROM
    tblSettlementProcessing AS sp INNER JOIN
	tblNegotiationRoadmap AS nr ON sp.SettlementID = nr.SettlementID INNER JOIN
	tblUser AS u ON sp.UserID = u.UserID INNER JOIN
	tblNegotiationSettlementStatus ON nr.SettlementStatusID = tblNegotiationSettlementStatus.SettlementStatusID
	and nr.SettlementStatusID in (6,8)
	join @vtblRoadMaps as nr2 on nr.RoadmapID = nr2.RoadmapID 
	join tblSettlements as s on s.SettlementID = nr.SettlementID
	left join @temp t on t.UserID = u.UserID
GROUP BY 
	u.userid
	, u.FirstName
	, u.LastName
	, t.ProcessedCurrentMonth
	, t.ProcessedLastMonth
ORDER BY
	u.FirstName
	, u.LastName

	
END
go

GRANT EXEC ON stp_NegotiationsProcessingStatistics TO PUBLIC