/****** Object:  Table [dbo].[tblNegotiationFilterXref]    Script Date: 01/28/2008 13:20:38 ******/
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblNegotiationFilterXref')
	BEGIN
			PRINT 'DO NOTHING'
	END	
ELSE
BEGIN

EXEC ('
CREATE TABLE [dbo].[tblNegotiationFilterXref](
	[RelationId] [int] IDENTITY(1,1) NOT NULL,
	[FilterId] [int] NULL,
	[EntityID] [int] NULL,
	[CreatedBy] [int] NULL,
	[Created] [datetime] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[Deleted] [bit] NULL CONSTRAINT [DF_tblNegotiationFilterXref_Deleted]  DEFAULT ((0)),
 CONSTRAINT [PK_tblNegotiationCriteriaXref] PRIMARY KEY CLUSTERED 
(
	[RelationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
')
END
GO