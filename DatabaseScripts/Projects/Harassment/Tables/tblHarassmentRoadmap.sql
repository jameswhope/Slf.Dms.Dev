CREATE TABLE [dbo].[tblHarassmentRoadmap](
	[HarassmentID] [int] IDENTITY(1,1) NOT NULL,
	[ClientSubmissionID] [int] NOT NULL,
	[HarassmentStatus] [int] NOT NULL,
	[MatterID] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblHarassmentRoadmap] PRIMARY KEY CLUSTERED 
(
	[HarassmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tblHarassmentRoadmap] ADD  CONSTRAINT [DF_tblHarassmentRoadmap_Created]  DEFAULT (getdate()) FOR [Created]
GO


