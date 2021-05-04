/****** Object:  Table [dbo].[tmpCommission]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpCommission](
	[accountnumber] [float] NULL,
	[hiredate] [datetime] NULL,
	[firstname] [nvarchar](255) NULL,
	[lastname] [nvarchar](255) NULL,
	[feecategory] [nvarchar](255) NULL,
	[settno] [nvarchar](255) NULL,
	[orgbal] [float] NULL,
	[begbal] [float] NULL,
	[pymtamount] [float] NULL,
	[endbal] [float] NULL,
	[Rate] [float] NULL,
	[Amount] [float] NULL
) ON [PRIMARY]
GO
