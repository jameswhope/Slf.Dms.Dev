 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblStateBracket]    Script Date: 01/12/2011 15:25:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblStateBracket]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblStateBracket](
	[StateBracketID] [int] IDENTITY(1,1) NOT NULL,
	[State] [char](2) NULL,
	[TaxYear] [nvarchar](4) NULL,
	[PayrollPeriod] [nvarchar](50) NULL,
	[MaritalStatus] [nvarchar](50) NULL,
	[AtLeast] [money] NULL,
	[ButLessThan] [money] NULL,
	[WithholdingAllowances_0] [money] NULL,
	[WithholdingAllowances_1] [money] NULL,
	[WithholdingAllowances_2] [money] NULL,
	[WithholdingAllowances_3] [money] NULL,
	[WithholdingAllowances_4] [money] NULL,
	[WithholdingAllowances_5] [money] NULL,
	[WithholdingAllowances_6] [money] NULL,
	[WithholdingAllowances_7] [money] NULL,
	[WithholdingAllowances_8] [money] NULL,
	[WithholdingAllowances_9] [money] NULL,
	[WithholdingAllowances_10] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF