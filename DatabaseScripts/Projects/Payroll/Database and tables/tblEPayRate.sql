USE [Payroll]
GO
/****** Object:  Table [dbo].[tblEPayRate]    Script Date: 01/12/2011 15:20:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEPayRate]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEPayRate](
	[EPayRateID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[EmployeeClass] [nvarchar](50) NULL,
	[PayType] [nvarchar](50) NULL,
	[StraightTimeHours] [int] NULL,
	[OTTimeAndHalfHours] [int] NULL,
	[OTDoubleTimeHours] [int] NULL,
	[PayRate] [money] NULL
) ON [PRIMARY]
END 