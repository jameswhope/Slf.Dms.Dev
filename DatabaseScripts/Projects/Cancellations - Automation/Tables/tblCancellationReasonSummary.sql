IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCancellationReasonSummary')
	BEGIN
		DROP  Table tblCancellationReasonSummary
	END
GO

CREATE TABLE [dbo].[tblCancellationReasonSummary](
	[MatterId] [int] NOT NULL,
	[CancellationSubReasonId] [int] NOT NULL,
	[Comment] [varchar](255) NULL,
	[AgencyName] [varchar](50) NULL,
	[AttorneyName] [varchar](50) NULL,
	[AttorneyAddress] [varchar](100) NULL,
	[AttorneyCity] [varchar](50) NULL,
	[AttorneyState] [varchar](5) NULL,
	[AttorneyZipCode] [varchar](6) NULL,
	[AttorneyPhone] [varchar](20) NULL,
	[AttorneyEmail] [varchar](255) NULL,
 CONSTRAINT [PK_tblCancellationReasonSummary] PRIMARY KEY CLUSTERED 
(
	[MatterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblCancellationReasonSummary]  WITH CHECK ADD  CONSTRAINT [FK_tblCancellationReasonSummary_tblCancellationReasonSummary] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblCancellationReasonSummary] ([MatterId])
GO
ALTER TABLE [dbo].[tblCancellationReasonSummary] CHECK CONSTRAINT [FK_tblCancellationReasonSummary_tblCancellationReasonSummary]
GO
ALTER TABLE [dbo].[tblCancellationReasonSummary]  WITH CHECK ADD  CONSTRAINT [FK_tblCancellationReasonSummary_tblClientCancellationSubReason] FOREIGN KEY([CancellationSubReasonId])
REFERENCES [dbo].[tblClientCancellationSubReason] ([CancellationSubReasonId])
GO
ALTER TABLE [dbo].[tblCancellationReasonSummary] CHECK CONSTRAINT [FK_tblCancellationReasonSummary_tblClientCancellationSubReason]
GO