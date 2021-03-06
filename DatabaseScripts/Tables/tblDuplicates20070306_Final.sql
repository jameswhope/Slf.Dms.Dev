/****** Object:  Table [dbo].[tblDuplicates20070306_Final]    Script Date: 11/19/2007 11:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDuplicates20070306_Final](
	[NachaDupID] [int] NOT NULL,
	[AccountNumber] [int] NULL,
	[Name] [nvarchar](255) NULL,
	[Amount] [money] NULL,
	[26th] [nvarchar](255) NULL,
	[27th] [nvarchar](255) NULL,
	[28th] [nvarchar](255) NULL,
	[OD Fees] [money] NULL,
	[Company] [nvarchar](255) NULL,
	[Total Due] [money] NULL,
	[F10] [nvarchar](255) NULL
) ON [PRIMARY]
GO
