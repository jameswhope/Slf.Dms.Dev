IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadNotes')
	BEGIN
		CREATE TABLE [dbo].[tblLeadNotes](
			[LeadNoteID] [int] IDENTITY(1,1) NOT NULL,
			[LeadApplicantID] [int] NULL,
			[LeadCreditorID] [int] NULL,
			[NoteTypeID] [int] NULL,
			[Subject] [nvarchar](200) NULL,
			[Value] [nvarchar](max) NULL,
			[Created] [datetime] NULL,
			[CreatedByID] [int] NULL,
			[Modified] [datetime] NULL,
			[ModifiedBy] [int] NULL,
			[NoteType] [varchar](10) NULL,
		 CONSTRAINT [PK_tblLeadNotes] PRIMARY KEY CLUSTERED 
		(
			[LeadNoteID] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]
	END


