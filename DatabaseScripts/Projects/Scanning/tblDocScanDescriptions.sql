IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDocScanDescriptions')
	BEGIN
		CREATE TABLE [tblDocScanDescriptions](
			[ScanDescriptionID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
			[DocID] [varchar](100) NOT NULL,
			[Description] [varchar](max) NOT NULL,
			[Created] [datetime] NOT NULL,
			[CreatedBy] [int] NOT NULL,
			[Modified] [datetime] NOT NULL,
			[ModifiedBy] [int] NOT NULL,
		 CONSTRAINT [PK_tblDocScanDescriptions] PRIMARY KEY CLUSTERED 
		(
			[ScanDescriptionID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY]

	
	END


GRANT SELECT ON tblDocScanDescriptions TO PUBLIC

GO

ALTER TABLE [dbo].[tblDocScanDescriptions] ADD  CONSTRAINT [DF_tblDocScanDescriptions_Created]  DEFAULT (getdate()) FOR [Created]
GO

ALTER TABLE [dbo].[tblDocScanDescriptions] ADD  CONSTRAINT [DF_tblDocScanDescriptions_Modified]  DEFAULT (getdate()) FOR [Modified]
GO