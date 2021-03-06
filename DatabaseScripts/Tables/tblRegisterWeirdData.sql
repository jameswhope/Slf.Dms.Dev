/****** Object:  Table [dbo].[tblRegisterWeirdData]    Script Date: 11/19/2007 11:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRegisterWeirdData](
	[RegisterId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[AccountID] [int] NULL,
	[TransactionDate] [datetime] NOT NULL,
	[CheckNumber] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Amount] [money] NOT NULL,
	[Balance] [money] NOT NULL,
	[EntryTypeId] [int] NOT NULL,
	[IsFullyPaid] [bit] NOT NULL,
	[Bounce] [datetime] NULL,
	[BounceBy] [int] NULL,
	[Void] [datetime] NULL,
	[VoidBy] [int] NULL,
	[Hold] [datetime] NULL,
	[HoldBy] [int] NULL,
	[Clear] [datetime] NULL,
	[ClearBy] [int] NULL,
	[ImportID] [int] NULL,
	[MediatorID] [int] NULL,
	[OldTable] [varchar](50) NULL,
	[OldID] [int] NULL,
	[ACHMonth] [int] NULL,
	[ACHYear] [int] NULL,
	[FeeMonth] [int] NULL,
	[FeeYear] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[AdjustedRegisterID] [int] NULL,
	[OriginalAmount] [money] NULL,
	[PFOBalance] [money] NOT NULL,
	[SDABalance] [money] NOT NULL,
	[RegisterSetID] [int] NULL,
	[InitialDraftYN] [bit] NULL,
	[CompanyID] [int] NULL,
	[BouncedReason] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
