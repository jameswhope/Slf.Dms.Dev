/****** Object:  Table [dbo].[BankAcctNos]    Script Date: 11/19/2007 11:02:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAcctNos](
	[Date Sent] [datetime] NULL,
	[Date Rec'd] [datetime] NULL,
	[FirstName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[SSN] [nvarchar](255) NULL,
	[Pmt Type] [nvarchar](255) NULL,
	[2nd Pull Date ] [datetime] NULL,
	[Pmt Amount] [money] NULL,
	[Debt Total ] [money] NULL,
	[Missing Info] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[Draft Date] [datetime] NULL,
	[Draft Amt] [money] NULL,
	[BankRoutingNumber] [nvarchar](255) NULL,
	[BankAccountNumber] [nvarchar](255) NULL,
	[Bank Name] [nvarchar](255) NULL,
	[Agent Name] [nvarchar](255) NULL
) ON [PRIMARY]
GO
