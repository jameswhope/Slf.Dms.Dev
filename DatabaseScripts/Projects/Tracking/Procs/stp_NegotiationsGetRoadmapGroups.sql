IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsGetRoadmapGroups')
	BEGIN
		DROP  Procedure  stp_NegotiationsGetRoadmapGroups
	END
GO
CREATE procedure [dbo].[stp_NegotiationsGetRoadmapGroups]
(
	@UserID int,
	@StatusGroupIDs varchar(max) = Null
)
as

declare @sql varchar(1000)

set @sql = '
SELECT
	nss.SettlementStatusID,
	nss.Name,
	count(*) as Total
FROM
	(
		SELECT
			max(RoadmapID) as RoadmapID,
			SettlementID
		FROM
			tblNegotiationRoadmap
		GROUP BY
			SettlementID
	) as nr2
	inner join tblNegotiationRoadmap as nr on nr.RoadmapID = nr2.RoadmapID
	inner join tblNegotiationSettlementStatus as nss on nss.SettlementStatusID = nr.SettlementStatusID
	inner join tblSettlementProcessing as sp on sp.SettlementID = nr2.SettlementID
WHERE
	(sp.UserID = ' + cast(@UserID as varchar) + ')'

if 	(@StatusGroupIDs is null)
	begin
		set @sql = @sql + ' and (nr.SettlementStatusID IN (5,9)'
	end
else
	begin
		set @sql = @sql + ' and (nr.SettlementStatusID IN ('+ @StatusGroupIDs +')'
	end

set @sql = @sql + ') GROUP BY nss.SettlementStatusID, nss.Name'

exec(@sql)