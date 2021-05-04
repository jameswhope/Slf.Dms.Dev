IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementClientApproval')
	BEGIN
		DROP  Table tblSettlementClientApproval
	END
GO

CREATE TABLE [dbo].[tblSettlementClientApproval](
	[MatterId] [int] NOT NULL,
	[ReasonId] [int] NULL,
	[ApprovalType] [varchar](50) NOT NULL,
	[NoteId] [int] NULL,
 CONSTRAINT [PK_tblSettlementClientApproval] PRIMARY KEY CLUSTERED 
(
	[MatterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblSettlementClientApproval]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementClientApproval_tblMatter] FOREIGN KEY([ReasonId])
REFERENCES [dbo].[tblClientRejectionReason] ([ReasonId])
GO
ALTER TABLE [dbo].[tblSettlementClientApproval] CHECK CONSTRAINT [FK_tblSettlementClientApproval_tblMatter]
GO
ALTER TABLE [dbo].[tblSettlementClientApproval]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlementClientApproval_tblNote] FOREIGN KEY([NoteId])
REFERENCES [dbo].[tblNote] ([NoteID])
GO
ALTER TABLE [dbo].[tblSettlementClientApproval] CHECK CONSTRAINT [FK_tblSettlementClientApproval_tblNote]
GO

GRANT SELECT ON tblSettlementClientApproval TO PUBLIC

GO

