/****** Object:  Table [dbo].[tblAccount]    Script Date: 11/19/2007 11:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAccount](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[CurrentCreditorInstanceID] [int] NULL,
	[AccountStatusID] [int] NULL,
	[OriginalAmount] [money] NOT NULL,
	[CurrentAmount] [money] NOT NULL,
	[SetupFeePercentage] [money] NOT NULL,
	[SettlementFeeCredit] [money] NULL,
	[OriginalDueDate] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[Settled] [datetime] NULL,
	[SettledBy] [int] NULL,
	[Removed] [datetime] NULL,
	[RemovedBy] [int] NULL,
	[SettledMediationID] [int] NULL,
	[UnverifiedAmount] [money] NULL,
	[UnverifiedRetainerFee] [money] NULL,
	[Verified] [datetime] NULL,
	[VerifiedAmount] [money] NULL,
	[VerifiedBy] [int] NULL,
	[VerifiedRetainerFee] [money] NULL,
	[OriginalCreditorInstanceID] [int] NULL,
 CONSTRAINT [PK_tblAccount] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
