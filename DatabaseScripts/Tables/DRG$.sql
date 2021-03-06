/****** Object:  Table [dbo].[DRG$]    Script Date: 11/19/2007 11:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DRG$](
	[Lead Number] [nvarchar](255) NULL,
	[Date Sent] [datetime] NULL,
	[Date Received] [datetime] NULL,
	[First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[Social Security No#] [nvarchar](255) NULL,
	[Payment Type] [nvarchar](255) NULL,
	[Seideman Pull Date] [datetime] NULL,
	[Payment Amount] [money] NULL,
	[Debt Total] [money] NULL,
	[Missing Info] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL
) ON [PRIMARY]
GO
