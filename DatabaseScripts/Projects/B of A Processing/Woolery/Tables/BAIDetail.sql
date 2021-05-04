 USE [WA]
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = '[Detail]')
	BEGIN
		DROP  Table [BAIDetail]
	END
GO

/****** Object:  Table [dbo].[BAIDetail]    Script Date: 03/15/2010 14:30:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BAIDetail](
	[Rpt_Date] [datetime] NULL,
	[Amount] [numeric](18, 2) NULL,
	[Account] [nvarchar](50) NULL,
	[ABA_Routing] [nvarchar](50) NULL,
	[Bank_Ref] [nvarchar](255) NULL,
	[Cust_Ref] [int] NULL,
	[FreeFormText] [nvarchar](max) NULL,
	[BAI_Code] [int] NULL,
	[BAI_Description] [nvarchar](255) NULL,
	[Amount_absolute_unformatted] [nvarchar](50) NULL,
	[Funds_Type] [nvarchar](255) NULL,
	[Distributed_Immediate_Availability] [numeric](18, 2) NULL,
	[Distributed_1_Day_Availability] [numeric](18, 2) NULL,
	[Distributed_>_1_Day_Availability] [numeric](18, 2) NULL,
	[Value_Date] [datetime] NULL,
	[Value_Time] [datetime] NULL
) ON [PRIMARY]