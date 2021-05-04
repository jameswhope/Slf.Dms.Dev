IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblStorageSolutionsLogs')
	BEGIN
		CREATE TABLE tblStorageSolutionsLogs(
			[StorageSolutionID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
			[SolutionTypeID] [int] NOT NULL,
			[SolutionStatusID] [int] NOT NULL,
			[SolutionStatusDate] [datetime] NULL,
			[Created] [datetime] NOT NULL CONSTRAINT [DF_tblStorageSolutionsLogs_Created]  DEFAULT (getdate()),
			[CreatedBy] [int] NOT NULL,
			[ArchiveLog] [ntext] NULL,
		 CONSTRAINT [PK_tblStorageSolutionsLogs] PRIMARY KEY CLUSTERED 
		(
			[StorageSolutionID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END




GRANT SELECT ON tblStorageSolutionsLogs TO PUBLIC


