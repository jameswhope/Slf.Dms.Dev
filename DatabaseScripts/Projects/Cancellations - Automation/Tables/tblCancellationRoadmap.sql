IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCancellationRoadmap')
	BEGIN
		DROP  Table tblCancellationRoadmap
	END
GO

CREATE TABLE tblCancellationRoadmap(
	[RoadmapId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NOT NULL,
	[MatterStatusCodeId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblCancellationRoadmap] PRIMARY KEY CLUSTERED 
(
	[RoadmapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCancellationRoadmap]  WITH CHECK ADD  CONSTRAINT [FK_tblCancellationRoadmap_tblMatter] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblMatter] ([MatterId])
GO
ALTER TABLE [dbo].[tblCancellationRoadmap] CHECK CONSTRAINT [FK_tblCancellationRoadmap_tblMatter]