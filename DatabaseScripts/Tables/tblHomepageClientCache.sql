/****** Object:  Table [dbo].[tblHomepageClientCache]    Script Date: 11/19/2007 11:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblHomepageClientCache](
	[HomepageClientCacheID] [int] IDENTITY(1,1) NOT NULL,
	[Month] [tinyint] NOT NULL,
	[Year] [smallint] NOT NULL,
	[CommRecID] [int] NULL,
	[Col] [int] NOT NULL,
	[ACH] [bit] NOT NULL,
	[TypeID] [int] NOT NULL,
	[CustomValue] [sql_variant] NULL,
	[CustomValue2] [sql_variant] NULL,
	[CustomValue3] [sql_variant] NULL,
 CONSTRAINT [PK_tblHomepageClientCache] PRIMARY KEY CLUSTERED 
(
	[HomepageClientCacheID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
