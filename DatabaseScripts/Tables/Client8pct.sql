/****** Object:  Table [dbo].[Client8pct]    Script Date: 11/19/2007 11:02:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client8pct](
	[ClientID] [int] NULL,
	[Date Sent] [datetime] NULL,
	[Date Rec'd] [datetime] NULL,
	[First Name] [nvarchar](255) NULL,
	[Last Name] [nvarchar](255) NULL,
	[SSN] [nvarchar](255) NULL,
	[Pmt Type] [nvarchar](255) NULL,
	[2nd Pull Date ] [datetime] NULL,
	[Pmt Amount] [money] NULL,
	[Debt Total ] [money] NULL,
	[Missing Info] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[Draft Date] [nvarchar](255) NULL,
	[Draft Amt] [nvarchar](255) NULL,
	[Bank Routing No] [nvarchar](255) NULL,
	[Bank Account No] [nvarchar](255) NULL,
	[Bank Name] [nvarchar](255) NULL,
	[Agent Name] [nvarchar](255) NULL
) ON [PRIMARY]
GO
