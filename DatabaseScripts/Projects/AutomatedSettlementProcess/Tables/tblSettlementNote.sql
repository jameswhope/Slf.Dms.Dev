IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementNote')
	BEGIN
		DROP  Table tblSettlementNote
	END
GO

CREATE TABLE [dbo].[tblSettlementNote](
	[SettlementNoteId] [int] IDENTITY(1,1) NOT NULL,
	[SettlementId] [int] NOT NULL,
	[Note] [varchar](max) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[NoteId] [int] NULL,
 CONSTRAINT [PK_tblSettlementNote] PRIMARY KEY CLUSTERED 
(
	[SettlementNoteId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblSettlementNote]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementNote_tblNote] FOREIGN KEY([NoteId])
REFERENCES [dbo].[tblNote] ([NoteID])
GO
ALTER TABLE [dbo].[tblSettlementNote] CHECK CONSTRAINT [FK_tblSettlementNote_tblNote]
GO
ALTER TABLE [dbo].[tblSettlementNote]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementNote_tblSettlements] FOREIGN KEY([SettlementId])
REFERENCES [dbo].[tblSettlements] ([SettlementID])
GO
ALTER TABLE [dbo].[tblSettlementNote] CHECK CONSTRAINT [FK_tblSettlementNote_tblSettlements]
GO


GRANT SELECT ON tblSettlementNote TO PUBLIC

GO

