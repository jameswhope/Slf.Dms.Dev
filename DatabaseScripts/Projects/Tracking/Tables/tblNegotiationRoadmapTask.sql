IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationRoadmapTask')
	BEGIN
		CREATE TABLE [dbo].[tblNegotiationRoadmapTask](
			[RoadmapTaskID] [int] IDENTITY(1,1) NOT NULL,
			[RoadmapID] [int] NOT NULL,
			[TaskID] [int] NOT NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL,
			[LastModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblNegotiationRoadmapTask] PRIMARY KEY CLUSTERED 
		(
			[RoadmapTaskID] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
	END

GRANT SELECT ON tblNegotiationRoadmapTask TO PUBLIC
