IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNonDepositRoadMap')
	BEGIN
		CREATE TABLE tblNonDepositRoadMap
(
   [RoadmapId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NOT NULL,
	[MatterStatusCodeId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[UserGroupId] [int] NULL
)
	END
GO


