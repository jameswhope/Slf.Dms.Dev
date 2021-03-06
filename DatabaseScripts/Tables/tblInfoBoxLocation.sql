/****** Object:  Table [dbo].[tblInfoBoxLocation]    Script Date: 11/19/2007 11:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInfoBoxLocation](
	[InfoBoxLocationID] [int] IDENTITY(1,1) NOT NULL,
	[ParentInfoBoxLocationID] [int] NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblInfoBoxLocation] PRIMARY KEY CLUSTERED 
(
	[InfoBoxLocationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
