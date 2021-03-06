/****** Object:  Table [dbo].[_tblFupList]    Script Date: 11/19/2007 11:02:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_tblFupList](
	[ClientID] [int] NULL,
	[LeadNumber] [nvarchar](255) NULL,
	[DateSent] [datetime] NULL,
	[DateReceived] [datetime] NULL,
	[FirstName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[SSN] [nvarchar](255) NULL,
	[PaymentType] [nvarchar](255) NULL,
	[PullDate] [datetime] NULL,
	[PaymentAmount] [money] NULL,
	[DebtTotal] [money] NULL,
	[MissingInfo] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[DraftDate] [datetime] NULL,
	[DraftAmount] [money] NULL,
	[BankRoutingNumber] [nvarchar](255) NULL,
	[BankAccountNumber] [nvarchar](255) NULL,
	[BankName] [nvarchar](255) NULL
) ON [PRIMARY]
GO
