IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDocumentRelations')
	BEGIN
		DROP  Table tblLeadDocumentRelations
	END
GO

CREATE TABLE tblLeadDocumentRelations  (
[LeadDocumentRelationID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[LeadApplicantID] [int] NOT NULL,
	[DocumentName] [varchar](250) NOT NULL,
	[DocumentPath] [varchar](max) NOT NULL,
	[RelatedDate] [datetime] NULL,
	[RelatedBy] [int] NULL
) ON [PRIMARY]


GRANT SELECT ON tblLeadDocumentRelations TO PUBLIC

