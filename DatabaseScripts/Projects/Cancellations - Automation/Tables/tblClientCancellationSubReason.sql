IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientCancellationSubReason')
	BEGIN
		DROP  Table tblClientCancellationSubReason
	END
GO

CREATE TABLE tblClientCancellationSubReason(
	[CancellationSubReasonId] [int] IDENTITY(1,1) NOT NULL,
	[CancellationReasonId] [int] NOT NULL,
	[CancellationSubReason] [varchar](100) NOT NULL,
 CONSTRAINT [PK_tblClientCancellationSubReason] PRIMARY KEY CLUSTERED 
(
	[CancellationSubReasonId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblClientCancellationSubReason]  WITH CHECK ADD  CONSTRAINT [FK_tblClientCancellationSubReason_tblClientCancellationReason] FOREIGN KEY([CancellationReasonId])
REFERENCES [dbo].[tblClientCancellationReason] ([CancellationReasonId])
GO
ALTER TABLE [dbo].[tblClientCancellationSubReason] CHECK CONSTRAINT [FK_tblClientCancellationSubReason_tblClientCancellationReason]
GO