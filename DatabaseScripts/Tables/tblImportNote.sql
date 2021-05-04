/****** Object:  Table [dbo].[tblImportNote]    Script Date: 11/19/2007 11:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblImportNote](
	[ImportNoteID] [int] NOT NULL,
	[ClientID] [int] NOT NULL,
	[Note] [varchar](8000) NOT NULL,
	[Created] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
