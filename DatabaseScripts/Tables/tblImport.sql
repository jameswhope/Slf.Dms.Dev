/****** Object:  Table [dbo].[tblImport]    Script Date: 11/19/2007 11:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblImport](
	[ImportID] [int] IDENTITY(1,1) NOT NULL,
	[Imported] [datetime] NOT NULL,
	[ImportedBy] [int] NOT NULL,
	[Database] [varchar](50) NULL,
	[Table] [varchar](255) NULL,
	[Description] [varchar](1000) NOT NULL,
	[MD5] [binary](16) NULL,
 CONSTRAINT [PK_tblImport] PRIMARY KEY CLUSTERED 
(
	[ImportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
