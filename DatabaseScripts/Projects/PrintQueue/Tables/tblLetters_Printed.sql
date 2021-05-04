IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLetters_Printed')
	BEGIN
		CREATE TABLE [tblLetters_Printed](
			[PrintID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
			[PrintDocTypeID] [varchar](20) NOT NULL,
			[PrintClientID] [int] NOT NULL,
			[PrintDocumentPath] [varchar](max) NOT NULL,
			[PrintDate] [datetime] NOT NULL,
			[PrintBy] [int] NOT NULL,
			[PrintDocumentPageCount] [int] NULL
		) ON [PRIMARY]

		GO

	

	END
GO


GRANT SELECT ON tblLetters_Printed TO PUBLIC

GO

	SET ANSI_PADDING OFF
		GO

		ALTER TABLE [tblLetters_Printed] ADD  CONSTRAINT [DF_tblLetters_Printed_PrintDate]  DEFAULT (getdate()) FOR [PrintDate]
		GO