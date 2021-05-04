 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblFedPercentage]    Script Date: 01/12/2011 15:23:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblFedPercentage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblFedPercentage](
	[FedPercentageID] [int] IDENTITY(1,1) NOT NULL,
	[TaxYear] [nvarchar](4) NULL,
	[PayrollPeriod] [nvarchar](50) NULL,
	[MaritalStatus] [char](1) NULL,
	[NotOver] [money] NULL,
	[Over] [money] NULL,
	[ButNotOver] [money] NULL,
	[Withhold] [money] NULL,
	[PlusPercent] [decimal](18, 0) NULL,
	[OfExcessOver] [money] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF