/****** Object:  Table [dbo].[_tblTheCor]    Script Date: 11/19/2007 11:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tblTheCor](
	[ClientID] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[BankRoutingNumber] [nvarchar](25) NOT NULL,
	[BankAccountNumber] [nvarchar](100) NOT NULL,
	[BankType] [nvarchar](50) NULL,
	[DepositAmount] [money] NOT NULL
) ON [PRIMARY]
GO
