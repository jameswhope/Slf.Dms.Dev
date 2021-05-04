/****** Object:  Table [dbo].[tblSDN_Address]    Script Date: 11/19/2007 11:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSDN_Address](
	[Ent_Num] [int] NULL,
	[Add_Num] [int] NULL,
	[Address] [varchar](750) NULL,
	[City] [varchar](50) NULL,
	[Country] [varchar](250) NULL,
	[Remarks] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
