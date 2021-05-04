IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlement_CheckPrint')
	BEGIN
		DROP  Table tblSettlement_CheckPrint
	END
GO

CREATE TABLE [dbo].[tblSettlement_CheckPrint](
	[CheckPrintId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NOT NULL,
	[BatchId] [int] NOT NULL,
	[PrintedBy] [int] NOT NULL,
	[PrintedDate] [datetime] NOT NULL,
	[IsPrinted] [bit] NOT NULL,
 CONSTRAINT [PK_tblSettlement_CheckPrint] PRIMARY KEY CLUSTERED 
(
	[CheckPrintId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblSettlement_CheckPrint]  WITH CHECK ADD  CONSTRAINT [FK_tblCheckPrint_tblCheckBatch] FOREIGN KEY([BatchId])
REFERENCES [dbo].[tblSettlement_CheckBatch] ([ProcessBatchId])
GO
ALTER TABLE [dbo].[tblSettlement_CheckPrint] CHECK CONSTRAINT [FK_tblCheckPrint_tblCheckBatch]

GRANT SELECT ON tblSettlement_CheckPrint TO PUBLIC

GO

