/****** Object:  Table [dbo].[All10Pct723]    Script Date: 11/19/2007 11:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[All10Pct723](
	[Date Sent] [datetime] NULL,
	[Date Rec'd] [datetime] NULL,
	[First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[SocialSecurity] [nvarchar](255) NULL,
	[Pmt Type] [nvarchar](255) NULL,
	[2nd Pull Date ] [datetime] NULL,
	[Pmt Amount] [money] NULL,
	[Debt Total ] [money] NULL,
	[Missing Info] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[DraftDate] [datetime] NULL,
	[Draft Amt] [money] NULL,
	[Bank Routing No] [text] NULL,
	[Bank Account No] [text] NULL,
	[Bank Name] [nvarchar](255) NULL,
	[Agent Name] [nvarchar](255) NULL,
	[ClientID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
