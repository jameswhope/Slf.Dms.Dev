/****** Object:  Table [dbo].[tblNachaReporting_Final]    Script Date: 11/19/2007 11:03:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNachaReporting_Final](
	[AccountNumber] [int] NULL,
	[ClientID] [int] NULL,
	[ClientName] [nvarchar](50) NULL,
	[twentythird] [nvarchar](50) NULL,
	[twentysixth] [nvarchar](50) NULL,
	[twentyseventh] [nvarchar](50) NULL,
	[Credited] [int] NULL,
	[Amount] [money] NULL
) ON [PRIMARY]
GO
