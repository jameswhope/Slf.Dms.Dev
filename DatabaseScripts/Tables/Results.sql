/****** Object:  Table [dbo].[Results]    Script Date: 11/19/2007 11:02:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Results](
	[Comments] [nvarchar](255) NULL,
	[Date Received] [smalldatetime] NULL,
	[Date Sent] [smalldatetime] NULL,
	[Debt Total] [money] NULL,
	[First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[Lead Number] [float] NULL,
	[Missing Info] [nvarchar](255) NULL,
	[Payment amount] [money] NULL,
	[Payment Type] [nvarchar](255) NULL,
	[Seideman Pull Date] [smalldatetime] NULL,
	[Social Security No#] [nvarchar](255) NULL
) ON [PRIMARY]
GO
