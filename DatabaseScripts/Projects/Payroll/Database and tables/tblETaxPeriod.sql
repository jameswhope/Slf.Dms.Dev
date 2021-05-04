USE [Payroll]
GO
/****** Object:  Table [dbo].[tblETaxPeriod]    Script Date: 01/12/2011 15:21:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblETaxPeriod]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblETaxPeriod](
	[ETaxPeriodID] [int] IDENTITY(1,1) NOT NULL,
	[YearWagesPaid] [int] NULL,
	[PayRollPeriod] [nvarchar](50) NULL,
	[FilingStatus] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL
) ON [PRIMARY]
END