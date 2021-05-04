IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationFilterParentXref')
	BEGIN
		DROP  Table tblNegotiationFilterParentXref
	END
GO

CREATE TABLE [dbo].[tblNegotiationFilterParentXref](
	[NegotiationFilterParentXrefID] [int] IDENTITY(1,1) NOT NULL,
	[FilterID] [int] NOT NULL,
	[ParentFilterID] [int] NOT NULL
) ON [PRIMARY]