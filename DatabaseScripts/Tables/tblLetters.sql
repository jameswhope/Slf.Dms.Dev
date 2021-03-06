/****** Object:  Table [dbo].[tblLetters]    Script Date: 11/19/2007 11:03:57 ******/
IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLetters')
	BEGIN
		CREATE TABLE [dbo].[tblLetters](
			[LetterID] [int] IDENTITY(1,1) NOT NULL,
			[LetterType] [nvarchar](50) NULL,
			[LetterBody] [text] NULL,
			[LetterSignedBy] [image] NULL,
			[LetterCompanyID] [int] NULL,
			[LetterAgencyID] [int] NULL,
			[LetterAttorneyID] [int] NULL,
			[LetterEmployeeID] [int] NULL,
			[LetterLogo] [image] NULL,
			[DocTypeID] [nvarchar](50) NULL,
		 CONSTRAINT [PK_tblLetters] PRIMARY KEY CLUSTERED 
		(
			[LetterID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	END
