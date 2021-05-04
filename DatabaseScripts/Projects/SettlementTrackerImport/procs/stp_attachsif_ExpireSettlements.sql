IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_attachsif_ExpireSettlements')
	BEGIN
		DROP  Procedure  stp_attachsif_ExpireSettlements
	END

GO

create procedure [dbo].[stp_attachsif_ExpireSettlements]
as
BEGIN
	declare @vtblRoadMaps table(SettlementStatusID int,settlementID int,roadmapid int)

	INSERT INTO
		@vtblRoadMaps
	SELECT
		max(SettlementStatusID) as SettlementStatusID,
		SettlementID,roadmapid=null
	FROM
		tblNegotiationRoadmap
	where year(created) = year(getdate()) and month(created) = month(getdate())
	GROUP BY
		SettlementID


	INSERT INTO [tblNegotiationRoadmap]([ParentRoadmapID],[SettlementID],[SettlementStatusID],[Reason],[Created],[CreatedBy],[LastModified],[LastModifiedBy])
	select distinct max(roadmapid),settlementid,9,'Settlement Due Date Expired',getdate(),-1,getdate(),-1 
	from tblNegotiationRoadmap 
	where settlementid in (select vr.settlementid
	from @vtblRoadMaps vr
	inner join tblsettlements s on s.settlementid = vr.settlementid and s.[active]=1 and s.[status] = 'a'
	where SettlementStatusID =5 and s.settlementduedate < dateadd(d,-1,getdate())) 
	group by settlementid
END


GO


GRANT EXEC ON stp_attachsif_ExpireSettlements TO PUBLIC

GO


