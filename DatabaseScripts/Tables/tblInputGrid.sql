/****** Object:  Table [dbo].[tblInputGrid]    Script Date: 11/19/2007 11:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInputGrid](
	[InputGridID] [int] IDENTITY(1,1) NOT NULL,
	[InputGridName] [varchar](255) NOT NULL,
 CONSTRAINT [PK_tblInputGrid] PRIMARY KEY CLUSTERED 
(
	[InputGridID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
