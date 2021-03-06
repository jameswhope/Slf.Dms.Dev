/****** Object:  Table [dbo].[tblReference]    Script Date: 11/19/2007 11:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblReference](
	[ReferenceID] [int] IDENTITY(1,1) NOT NULL,
	[Table] [varchar](50) NOT NULL,
	[KeyField] [varchar](50) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[TitlePlural] [varchar](50) NOT NULL,
	[LastWord] [varchar](50) NOT NULL,
	[LastWordPlural] [varchar](50) NOT NULL,
	[IconSrc] [varchar](50) NOT NULL,
	[IconNewSrc] [varchar](50) NOT NULL,
	[Add] [bit] NOT NULL CONSTRAINT [DF_tblReference_Edit]  DEFAULT (0),
	[Edit] [bit] NOT NULL CONSTRAINT [DF_tblReference_Edit_1]  DEFAULT (0),
	[Delete] [bit] NOT NULL CONSTRAINT [DF_tblReference_Delete]  DEFAULT (0),
	[InfoBoxMessage] [varchar](1000) NULL,
 CONSTRAINT [PK_tblReference] PRIMARY KEY CLUSTERED 
(
	[ReferenceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
