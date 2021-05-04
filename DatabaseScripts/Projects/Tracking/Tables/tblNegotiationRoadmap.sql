IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationRoadmap')
	BEGIN
		CREATE TABLE [dbo].[tblNegotiationRoadmap](
			[RoadmapID] [int] IDENTITY(1,1) NOT NULL,
			[ParentRoadmapID] [int] NULL,
			[SettlementID] [int] NOT NULL,
			[SettlementStatusID] [int] NOT NULL,
			[Reason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL,
			[LastModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblNegotiationRoadmap] PRIMARY KEY CLUSTERED 
		(
			[RoadmapID] ASC
		)WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
		) ON [PRIMARY]
	END

GRANT SELECT ON tblNegotiationRoadmap TO PUBLIC


