/****** Object:  Table [dbo].[tblRegister]    Script Date: 11/19/2007 11:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRegister](
	[RegisterId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[AccountID] [int] NULL,
	[TransactionDate] [datetime] NOT NULL,
	[CheckNumber] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Amount] [money] NOT NULL,
	[Balance] [money] NOT NULL CONSTRAINT [DF_tblRegister_Balance]  DEFAULT (0),
	[EntryTypeId] [int] NOT NULL,
	[IsFullyPaid] [bit] NOT NULL CONSTRAINT [DF_tblRegister_IsFullyPaid]  DEFAULT (0),
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
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblRegister_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[AdjustedRegisterID] [int] NULL,
	[OriginalAmount] [money] NULL,
	[PFOBalance] [money] NOT NULL CONSTRAINT [DF_tblRegister_PFOBalance]  DEFAULT (0),
	[SDABalance] [money] NOT NULL CONSTRAINT [DF_tblRegister_SDABalance]  DEFAULT (0),
	[RegisterSetID] [int] NULL,
	[InitialDraftYN] [bit] NULL,
	[CompanyID] [int] NULL,
	[BouncedReason] [int] NULL,
 CONSTRAINT [PK_tblRegister] PRIMARY KEY CLUSTERED 
(
	[RegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblRegister_7_1858873739__K10_K9_K13_K11_K7] ON [dbo].[tblRegister] 
(
	[IsFullyPaid] ASC,
	[EntryTypeId] ASC,
	[Void] ASC,
	[Bounce] ASC,
	[Amount] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_tblRegister_7_1858873739__K2_K1] ON [dbo].[tblRegister] 
(
	[ClientId] ASC,
	[RegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
