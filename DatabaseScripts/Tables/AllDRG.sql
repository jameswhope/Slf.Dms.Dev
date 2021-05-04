/****** Object:  Table [dbo].[AllDRG]    Script Date: 11/19/2007 11:02:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllDRG](
	[Lead Number] [nvarchar](255) NULL,
	[Date Sent] [datetime] NULL,
	[Date Received] [datetime] NULL,
	[First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[SocialSecurity] [nvarchar](255) NULL,
	[Payment Type] [nvarchar](255) NULL,
	[2nd  Pull Date] [datetime] NULL,
	[Payment Amount] [money] NULL,
	[Debt Total] [money] NULL,
	[Missing Info] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[DraftDate] [datetime] NULL,
	[Draft Amount] [money] NULL,
	[Bank Routing No] [text] NULL,
	[Bank Account No] [text] NULL,
	[Bank Name] [nvarchar](255) NULL,
	[Agent Name] [nvarchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
