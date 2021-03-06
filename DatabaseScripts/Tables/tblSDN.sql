/****** Object:  Table [dbo].[tblSDN]    Script Date: 11/19/2007 11:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSDN](
	[ent_num] [int] NULL,
	[SDN_Name] [varchar](350) NULL,
	[SDN_Type] [varchar](12) NULL,
	[Program] [nvarchar](50) NULL,
	[Title] [varchar](200) NULL,
	[Call_Sign] [varchar](8) NULL,
	[Vess_Type] [varchar](1000) NULL,
	[Tonnage] [varchar](14) NULL,
	[GRT] [varchar](8) NULL,
	[Vess_Flag] [varchar](40) NULL,
	[Vess_Owner] [varchar](150) NULL,
	[Remarks] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
