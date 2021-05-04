IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadStatusRoadmap')
	BEGIN
		
		CREATE TABLE [dbo].[tblLeadStatusRoadmap](
			[RoadmapID] [int] IDENTITY(1,1) NOT NULL,
			[ParentRoadmapID] [int] NULL,
			[LeadApplicantID] [int] NOT NULL,
			[LeadStatusID] [int] NOT NULL,
			[Reason] [varchar](255) NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[LastModified] [datetime] NOT NULL,
			[LastModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblLeadStatusRoadMap] PRIMARY KEY CLUSTERED 
		(
			[RoadmapID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]

	END
GO


GRANT SELECT ON tblLeadStatusRoadmap TO PUBLIC

