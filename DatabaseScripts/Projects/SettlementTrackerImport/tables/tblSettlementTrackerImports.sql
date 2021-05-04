IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementTrackerImports')
	BEGIN
		
CREATE TABLE [dbo].[tblSettlementTrackerImports](
	[TrackerImportID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[TrackerImportBatchID] [varchar](255) NOT NULL,
	[Team] [nvarchar](255) NULL,
	[Negotiator] [nvarchar](255) NULL,
	[AgencyID] [int] NULL,
	[LawFirm] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[Status] [varchar](10) NULL,
	[Due] [datetime] NULL,
	[ClientAcctNumber] [numeric](18, 0) NULL,
	[Name] [nvarchar](255) NULL,
	[CreditorAccountNum] [varchar](50) NULL,
	[OriginalCreditor] [nvarchar](255) NULL,
	[CurrentCreditor] [nvarchar](255) NULL,
	[BALANCE] [money] NULL,
	[SettlementAmt] [money] NULL,
	[SettlementPercent] [float] NULL,
	[FundsAvail] [money] NULL,
	[Note] [varchar](max) NULL,
	[sent] [datetime] NULL,
	[paid] [datetime] NULL,
	[days] [int] NULL,
	[ClientSavings] [money] NULL,
	[SettlementFees] [money] NULL,
	[SettlementSavingsPct] [float] NULL,
	[ImportDate] [datetime] NOT NULL,
	[ImportBy] [int] NULL,
	[CancelDate] [datetime] NULL,
	[CancelBy] [int] NULL,
	[SettlementID] [numeric](18, 0),
	[Expired] [datetime] NULL,
 CONSTRAINT [PK_tblSettlementTrackerImports] PRIMARY KEY CLUSTERED 
(
	[TrackerImportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



	END


GRANT SELECT ON tblSettlementTrackerImports TO PUBLIC
