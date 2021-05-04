IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAccount_PaymentProcessing')
	BEGIN
		DROP  Table tblAccount_PaymentProcessing
	END
GO

CREATE TABLE [tblAccount_PaymentProcessing](
	[PaymentProcessingId] [int] IDENTITY(1,1) NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[AvailableSDA] [money] NOT NULL,
	[MatterId] [int] NOT NULL,
	[RequestType] [varchar](50) NOT NULL,
	[CheckNumber] [int] NULL,
	[DeliveryMethod] [varchar](25) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[Processed] [bit] NOT NULL CONSTRAINT [DF_tblSettlement_CheckProcessing_Processed]  DEFAULT ((0)),
	[ReferenceNumber] [varchar](50) NULL,
	[CheckAmount] [money] NULL,
	[BatchId] [int] NULL,
	[IsCheckPrinted] [bit] NOT NULL CONSTRAINT [DF_tblSettlement_CheckProcessing_IsCheckPrinted]  DEFAULT ((0)),
	[ProcessedDate] [datetime] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedBy] [int] NULL,
	[IsApproved] [bit] NULL,
	[PreApprovedDate] [datetime] NULL,
	[PreApprovedBy] [int] NULL,
	[IsPreApproved] [bit] default(0) NOT NULL,
 CONSTRAINT [PK_tblSettlement_CheckProcessing] PRIMARY KEY CLUSTERED 
(
	[PaymentProcessingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblAccount_PaymentProcessing]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlement_CheckProcessing_tblMatter] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblMatter] ([MatterId])
GO
ALTER TABLE [dbo].[tblAccount_PaymentProcessing] CHECK CONSTRAINT [FK_tblSettlement_CheckProcessing_tblMatter]
GO


GRANT SELECT ON tblAccount_PaymentProcessing TO PUBLIC

GO