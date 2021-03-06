/****** Object:  Table [dbo].[tblNoteTemplateVariables]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblNoteTemplateVariables](
	[NoteTemplateID] [numeric](18, 0) NOT NULL,
	[NoteTemplateVariableID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[NoteTemplateVariableName] [varchar](50) NOT NULL,
	[NoteTemplateVariableValues] [varchar](max) NULL,
	[NoteTemplateVariableValueType] [varchar](1) NULL,
 CONSTRAINT [PK_tblNoteTemplateVariables] PRIMARY KEY CLUSTERED 
(
	[NoteTemplateVariableID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblNoteTemplateVariables]  WITH CHECK ADD  CONSTRAINT [FK_tblNoteTemplateVariables_tblNoteTemplates] FOREIGN KEY([NoteTemplateID])
REFERENCES [dbo].[tblNoteTemplates] ([NoteTemplateID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tblNoteTemplateVariables] CHECK CONSTRAINT [FK_tblNoteTemplateVariables_tblNoteTemplates]
GO
