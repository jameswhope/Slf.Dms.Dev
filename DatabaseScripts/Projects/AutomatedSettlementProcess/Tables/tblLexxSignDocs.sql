IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLexxSignDocs')
	BEGIN
		CREATE TABLE [tblLexxSignDocs](
	[LexxSignDocumentID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[DocumentId] [varchar](50) NULL,
	[AuthToken] [varchar](50) NULL,
	[Submitted] [datetime] NOT NULL,
	[SubmittedBy] [int] NOT NULL,
	[SignatoryEmail] [varchar](75) NULL,
	[CurrentStatus] [varchar](50) NULL,
	[Completed] [datetime] NULL,
	[DocumentTypeID] [varchar](10) NOT NULL,
	[SigningBatchID] [varchar](50) NULL,
	[SigningIPAddress] [varchar](50) NULL,
	[SigningBrowserName] [varchar](50) NULL,
	[SigningBrowserVersion] [varchar](50) NULL,
	[SigningBrowserJSEnabled] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[LexxSignDocumentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
	END
GO



GRANT SELECT ON tblLexxSignDocs TO PUBLIC

GO

ALTER TABLE [dbo].[tblLexxSignDocs] ADD  DEFAULT (getdate()) FOR [Submitted]
GO

ALTER TABLE [dbo].[tblLexxSignDocs] ADD  DEFAULT ((6)) FOR [DocumentTypeID]
GO