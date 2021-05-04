IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAccountEntityXref')
	BEGIN
		DROP  Table tblAccountEntityXref
	END
GO

CREATE TABLE [dbo].[tblAccountEntityXref](
	[AccountID] [int] NOT NULL,
	[EntityID] [int] NOT NULL
) ON [PRIMARY]


GRANT SELECT ON tblAccountEntityXref TO PUBLIC

