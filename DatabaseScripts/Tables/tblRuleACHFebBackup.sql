/****** Object:  Table [dbo].[tblRuleACHFebBackup]    Script Date: 11/19/2007 11:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRuleACHFebBackup](
	[RuleACHId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[DepositDay] [int] NOT NULL,
	[DepositAmount] [money] NOT NULL,
	[BankName] [varchar](50) NOT NULL,
	[BankRoutingNumber] [varchar](50) NOT NULL,
	[BankAccountNumber] [varchar](50) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[BankType] [varchar](1) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
