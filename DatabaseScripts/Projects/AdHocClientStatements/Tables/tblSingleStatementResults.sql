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
SET ANSI_PADDING OFF

/*
GRANT SELECT ON Table_Name TO PUBLIC

GO
*/
