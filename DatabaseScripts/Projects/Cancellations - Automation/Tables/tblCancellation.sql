IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCancellation')
	BEGIN
		DROP  Table tblCancellation
	END
GO

CREATE TABLE [dbo].[tblCancellation](
	[CancellationId] [int] IDENTITY(1,1) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[ClientId] [int] NOT NULL,
	[HasAssociatedMatters] [bit] NOT NULL,
	[HasLegalMatters] [bit] NOT NULL,
	[MatterId] [int] NOT NULL,
	[Deleted] [datetime] NULL,
	[DeletedBy] [int] NULL,
	[IsFeeOwed] [bit] NOT NULL,
	[IsSDAFundsAvailable] [bit] NOT NULL,
	[ClientRequestedRefund] [bit] NULL,
	[RetainerFeeRefundsRequested] [int] NULL,
	[MaintFeeRefundsRequested] [int] NULL,
	[CreatedOnStatusChanged] [int] NULL,
	[CancellationSurveyId] [int] NULL,
	[TotalRefund] [money] NULL,
	[ApprovedBy] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[ClientAgreedToPay] [bit] NULL,	
 CONSTRAINT [PK_tblCancellations] PRIMARY KEY CLUSTERED 
(
	[CancellationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCancellation]  WITH CHECK ADD  CONSTRAINT [FK_tblCancellation_tblClient] FOREIGN KEY([ClientId])
REFERENCES [dbo].[tblClient] ([ClientID])
GO
ALTER TABLE [dbo].[tblCancellation] CHECK CONSTRAINT [FK_tblCancellation_tblClient]
GO
ALTER TABLE [dbo].[tblCancellation]  WITH CHECK ADD  CONSTRAINT [FK_tblCancellation_tblMatter] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblMatter] ([MatterId])
GO
ALTER TABLE [dbo].[tblCancellation] CHECK CONSTRAINT [FK_tblCancellation_tblMatter]
GO

