/****** Object:  Table [dbo].[tblNoteRelation]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNoteRelation](
	[NoteRelationID] [int] IDENTITY(1,1) NOT NULL,
	[NoteID] [int] NULL,
	[RelationTypeID] [int] NULL,
	[RelationID] [int] NULL,
 CONSTRAINT [PK_tblNoteRelation] PRIMARY KEY CLUSTERED 
(
	[NoteRelationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
