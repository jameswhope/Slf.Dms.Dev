/****** Object:  Table [dbo].[tblNoteTemplates]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNoteTemplates](
	[NoteTemplateID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[NoteTemplateDocTypeID] [nvarchar](50) NOT NULL,
	[NoteTemplateText] [ntext] NOT NULL,
 CONSTRAINT [PK_tblNoteTemplates] PRIMARY KEY CLUSTERED 
(
	[NoteTemplateID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
