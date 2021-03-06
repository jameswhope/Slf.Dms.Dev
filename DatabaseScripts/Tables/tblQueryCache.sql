/****** Object:  Table [dbo].[tblQueryCache]    Script Date: 11/19/2007 11:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblQueryCache](
	[QueryCacheID] [int] IDENTITY(1,1) NOT NULL,
	[ClassName] [varchar](50) NOT NULL,
	[QueryName] [varchar](50) NULL,
	[Row] [int] NULL,
	[Col] [int] NULL,
	[CustomID] [sql_variant] NULL,
	[Value] [sql_variant] NOT NULL,
 CONSTRAINT [PK_tblQueryCache] PRIMARY KEY CLUSTERED 
(
	[QueryCacheID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
