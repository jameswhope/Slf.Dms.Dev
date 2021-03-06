/****** Object:  Table [dbo].[tblStatementPersonal]    Script Date: 11/19/2007 11:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStatementPersonal](
	[clientid] [int] NOT NULL,
	[accountnumber] [varchar](50) NULL,
	[BaseCompany] [int] NULL,
	[Name] [varchar](101) NOT NULL,
	[Street] [varchar](511) NULL,
	[City] [varchar](50) NULL,
	[ST] [varchar](50) NULL,
	[Zip] [varchar](5) NULL,
	[period] [varchar](64) NULL,
	[DepDate] [nvarchar](93) NULL,
	[DepAmt] [money] NULL,
	[PFOBalance] [money] NULL,
	[ACH] [varchar](1) NOT NULL,
	[NoChecks] [varchar](1) NOT NULL,
	[Payee] [varchar](50) NOT NULL,
	[cslocation1] [nvarchar](150) NOT NULL,
	[cslocation2] [nvarchar](95) NOT NULL,
	[desc1] [nvarchar](15) NOT NULL,
	[desc2] [nvarchar](255) NULL,
	[desc3] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
