IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementRoadmap')
	BEGIN
		DROP  Table tblSettlementRoadmap
	END
GO

CREATE TABLE [dbo].[tblSettlementRoadmap](
	[SettlementRoadmapId] [int] IDENTITY(1,1) NOT NULL,
	[MatterStatusCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[NoteId] [int] NULL,
	[SettlementId] [int] NOT NULL,
 CONSTRAINT [PK_tblSettlementRoadmap] PRIMARY KEY CLUSTERED 
(
	[SettlementRoadmapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblSettlementRoadmap]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementRoadmap_tblMatterStatusCode] FOREIGN KEY([MatterStatusCodeId])
REFERENCES [dbo].[tblMatterStatusCode] ([MatterStatusCodeId])
GO
ALTER TABLE [dbo].[tblSettlementRoadmap] CHECK CONSTRAINT [FK_tblSettlementRoadmap_tblMatterStatusCode]
GO
ALTER TABLE [dbo].[tblSettlementRoadmap]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementRoadmap_tblNote] FOREIGN KEY([NoteId])
REFERENCES [dbo].[tblNote] ([NoteID])
GO
ALTER TABLE [dbo].[tblSettlementRoadmap] CHECK CONSTRAINT [FK_tblSettlementRoadmap_tblNote]
GO
ALTER TABLE [dbo].[tblSettlementRoadmap]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementRoadmap_tblSettlements] FOREIGN KEY([SettlementId])
REFERENCES [dbo].[tblSettlements] ([SettlementID])
GO
ALTER TABLE [dbo].[tblSettlementRoadmap] CHECK CONSTRAINT [FK_tblSettlementRoadmap_tblSettlements]
GO

/*
GRANT SELECT ON Table_Name TO PUBLIC

GO
*/
