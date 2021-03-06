/****** Object:  Table [dbo].[tblMediation]    Script Date: 11/19/2007 11:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMediation](
	[MediationID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[RegisterBalance] [money] NULL,
	[AccountBalance] [money] NULL,
	[SettlementPercentage] [money] NULL,
	[SettlementAmount] [money] NULL,
	[AmountAvailable] [money] NULL,
	[AmountBeingSent] [money] NULL,
	[DueDate] [datetime] NULL,
	[Savings] [money] NULL,
	[SettlementFee] [money] NULL,
	[OvernightDeliveryAmount] [money] NULL,
	[SettlementCost] [money] NULL,
	[AvailableAfterSettlement] [money] NULL,
	[AmountBeingPaid] [money] NULL,
	[AmountStillOwed] [money] NULL,
	[Status] [varchar](50) NULL,
	[FrozenAmount] [money] NULL,
	[FrozenDate] [datetime] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[SettlementNotes] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblMediation] PRIMARY KEY CLUSTERED 
(
	[MediationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
