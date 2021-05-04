IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_MaxSettlementStep')
	BEGIN
		DROP  View vw_MaxSettlementStep
	END
GO

CREATE View vw_MaxSettlementStep AS
	SELECT
		max(RoadmapID) as RoadmapID,
		SettlementID
	FROM
		tblNegotiationRoadmap
	GROUP BY
		SettlementID


GO


GRANT SELECT ON vw_MaxSettlementStep TO PUBLIC

GO

