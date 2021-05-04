IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNacha_check21')
	BEGIN
		CREATE TABLE [dbo].[tblNacha_Check21](
			[Check21ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
			[RegisterID] [int] NOT NULL,
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
			[Created] [datetime] NOT NULL CONSTRAINT [DF_tblNacha_Check21_Created]  DEFAULT (getdate()),
			[CreatedBy] [int] NOT NULL,
			[Processed] [datetime] NULL,
			[ProcessedBy] [int] NULL,
			[Verified] [datetime] NULL,
			[VerifiedBy] [int] NULL,
			[SaveGUID] [varchar](50) NULL
		) ON [PRIMARY]
	END


GRANT SELECT ON tblNacha_check21 TO PUBLIC

