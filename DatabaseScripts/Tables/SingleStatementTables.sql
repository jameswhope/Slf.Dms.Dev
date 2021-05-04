IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSingleStatementResults')
	BEGIN
		DROP  Table tblSingleStatementResults
	END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSingleStatementResults](
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
	[NumPhoneCalls] [int] NULL
) ON [PRIMARY]

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSingleStatementPersonal')
	BEGIN
		DROP  Table tblSingleStatementPersonal
	END
GO

CREATE TABLE [dbo].[tblSingleStatementPersonal](
	[clientid] [int] NOT NULL,
	[accountnumber] [varchar](50) NULL,
	[BaseCompany] [int] NULL,
	[Name] [varchar](101) NOT NULL,
	[Street] [varchar](511) NULL,
	[City] [varchar](50) NULL,
	[ST] [varchar](50) NULL,
	[Zip] [varchar](5) NULL,
	[period] [varchar](64) NULL,
	[DepDate] [nvarchar](93) NULL,
	[DepAmt] [money] NULL,
	[PFOBalance] [money] NULL,
	[ACH] [varchar](1) NOT NULL,
	[NoChecks] [varchar](1) NOT NULL,
	[Payee] [varchar](160) NULL,
	[cslocation1] [nvarchar](150) NOT NULL,
	[cslocation2] [nvarchar](95) NOT NULL,
	[desc1] [nvarchar](15) NOT NULL,
	[desc2] [nvarchar](255) NULL,
	[desc3] [varchar](1) NOT NULL
) ON [PRIMARY]

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSingleStatementCreditor')
	BEGIN
		DROP  Table tblSingleStatementCreditor
	END
GO

CREATE TABLE [dbo].[tblSingleStatementCreditor](
	[Acct_No] [nvarchar](255) NULL,
	[Cred_Name] [nvarchar](255) NULL,
	[Orig_Acct_No] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Balance] [money] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

