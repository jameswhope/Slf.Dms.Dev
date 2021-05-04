IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlement_AdjustedFeeDetail')
	BEGIN
		DROP  Table tblSettlement_AdjustedFeeDetail
	END
GO

CREATE TABLE [dbo].[tblSettlement_AdjustedFeeDetail](
	[AdjustedFeeId] [int] IDENTITY(1,1) NOT NULL,
	[SettlementId] [int] NOT NULL,
	[NewAmount] [money] NULL,
	[AdjustedBy] [int] NOT NULL,
	[AdjustedDate] [datetime] NOT NULL,
	[EntryTypeId] [int] NOT NULL,
	[AdjustedReason] [varchar](250) NULL,
	[Approved] [bit] NULL,
	[ApprovedBy] [int] NULL,
	[ApprovedDate] [int] NULL,
	[IsDeleted] [bit] NULL,
	[Deleted] [datetime] NULL,
	[DeletedBy] [int] NULL,
 CONSTRAINT [PK_tblSettlement_AdjustedFeeDetail] PRIMARY KEY CLUSTERED 
(
	[AdjustedFeeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblSettlement_AdjustedFeeDetail]  WITH CHECK ADD  CONSTRAINT [FK_tblAdjustedFeeDetail_tblSettlement] FOREIGN KEY([SettlementId])
REFERENCES [dbo].[tblSettlements] ([SettlementID])
GO
ALTER TABLE [dbo].[tblSettlement_AdjustedFeeDetail] CHECK CONSTRAINT [FK_tblAdjustedFeeDetail_tblSettlement]


GRANT SELECT ON [tblSettlement_AdjustedFeeDetail] TO PUBLIC

GO

