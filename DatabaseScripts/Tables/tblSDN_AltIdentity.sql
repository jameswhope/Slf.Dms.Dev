/****** Object:  Table [dbo].[tblSDN_AltIdentity]    Script Date: 11/19/2007 11:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSDN_AltIdentity](
	[ent_num] [int] NULL,
	[alt_num] [int] NULL,
	[alt_type] [varchar](8) NULL,
	[alt_name] [varchar](350) NULL,
	[alt_remarks] [nvarchar](350) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
