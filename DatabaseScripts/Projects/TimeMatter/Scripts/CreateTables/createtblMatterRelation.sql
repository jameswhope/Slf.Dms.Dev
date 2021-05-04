 
/*** add tblMatterRelation for generic creation of Matter as generic ticketing function  ****/
/*** Revision 0 1/05/2010 ****/

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'tblMatterRelation')
BEGIN

	
CREATE TABLE [dbo].[tblMatterRelation](
	[MatterRelationID] [int] IDENTITY(1,1) NOT NULL,
	[MatterID] [int] NULL,
	[RelationTypeID] [int] NULL,
	[RelationID] [int] NULL,
 CONSTRAINT [PK_tblMatterRelation] PRIMARY KEY CLUSTERED 
(
	[MatterRelationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]



END
