IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblICLChecks')
	BEGIN
		CREATE TABLE [dbo].[tblICLChecks](
	[Check21ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[RegisterID] [int] NOT NULL,
	[ClientID] [nchar](10) NULL,
	[CheckRouting] [varchar](20) NULL,
	[CheckAccountNum] [varchar](20) NULL,
	[CheckAmount] [money] NULL,
	[CheckAuxOnus] [varchar](20) NULL,
	[CheckNumber] [varchar](50) NULL,
	[CheckType] [varchar](50) NULL,
	[CheckOnUs] [varchar](50) NULL,
	[CheckRoutingCheckSum] [varchar](1) NULL,
	[CheckMicrLine] [varchar](200) NULL,
	[CheckFrontPath] [varchar](max) NOT NULL,
	[CheckBackPath] [varchar](max) NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_tblICLChecks_Created]  DEFAULT (getdate()),
	[CreatedBy] [int] NOT NULL,
	[Processed] [datetime] NULL,
	[ProcessedBy] [int] NULL,
	[Verified] [datetime] NULL,
	[VerifiedBy] [int] NULL,
	[SaveGUID] [varchar](50) NULL,
	[DeleteDate] [datetime] NULL,
 CONSTRAINT [PK_tblICLChecks] PRIMARY KEY CLUSTERED 
(
	[Check21ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	END


GRANT SELECT ON tblICLChecks TO PUBLIC

