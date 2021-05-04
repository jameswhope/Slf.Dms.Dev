IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements_SpecialInstructions')
	BEGIN
		CREATE TABLE [dbo].[tblSettlements_SpecialInstructions](
			[spID] [numeric](18, 0) IDENTITY(1,1) ,
			[SettlementID] [numeric](18, 0) NULL,
			[SpecialInstructions] [ntext] NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [nchar](10) NOT NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END
GO

GRANT SELECT ON tblSettlements_SpecialInstructions TO PUBLIC

GO

