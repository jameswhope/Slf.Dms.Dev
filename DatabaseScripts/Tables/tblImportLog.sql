/****** Object:  Table [dbo].[tblImportLog]    Script Date: 11/19/2007 11:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblImportLog](
	[ImportLogID] [int] IDENTITY(1,1) NOT NULL,
	[ImportID] [int] NOT NULL,
	[Value] [text] NOT NULL,
 CONSTRAINT [PK_tblImportLog] PRIMARY KEY CLUSTERED 
(
	[ImportLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
