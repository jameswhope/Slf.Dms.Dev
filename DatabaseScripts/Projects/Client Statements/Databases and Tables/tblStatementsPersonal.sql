 USE [ClientStatements]
GO
/****** Object:  Table [dbo].[tblStatementResults]    Script Date: 01/05/2011 08:47:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblStatementResults]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblStatementResults](
	[ClientID] [int] NULL,
	[AccountNumber] [int] NULL,
	[RegisterFirst] [int] NULL,
	[registerID] [int] NULL,
	[TransactionDate] [datetime] NULL,
	[CheckNo] [varchar](200) NULL,
	[EntryTypeID] [int] NULL,
	[EntryTypeName] [nvarchar](100) NULL,
	[OrigionalAmt] [money] NULL,
	[Amount] [money] NULL,
	[SDABalance] [money] NULL,
	[PFOBalance] [money] NULL,
	[description] [varchar](1000) NULL,
	[AccountID] [int] NULL,
	[CreditorName] [nvarchar](255) NULL,
	[CreditorAcctNo] [nvarchar](255) NULL,
	[CurrentAmount] [money] NULL,
	[AdjustRegisterID] [int] NULL,
	[AdjTransactionDate] [datetime] NULL,
	[AdjRegAmount] [money] NULL,
	[AdjRegOrigAmount] [money] NULL,
	[AdjRegEntryTypeID] [int] NULL,
	[AdjRegAcctID] [int] NULL,
	[AdjRegAcctCreditorName] [nvarchar](255) NULL,
	[AdjRegAcctAcctNo] [nvarchar](255) NULL,
	[ACHMonth] [nvarchar](255) NULL,
	[ACHYear] [nvarchar](255) NULL,
	[FeeMonth] [nvarchar](255) NULL,
	[FeeYear] [nvarchar](255) NULL,
	[BounceOrVoid] [int] NULL,
	[NumNotes] [int] NULL,
	[NumPhoneCalls] [int] NULL,
	[StmtPeriod] [nvarchar](50) NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF