 USE [WA]
GO
/****** Object:  Table [dbo].[tblEMSDailyTransactionJournal]    Script Date: 10/06/2010 14:23:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEMSDailyTransactionJournal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEMSDailyTransactionJournal](
	[Code] [nvarchar](6) NULL,
	[Sub] [nvarchar](16) NULL,
	[Group] [nvarchar](10) NULL,
	[TinDate] [nvarchar](50) NULL,
	[Amount] [nvarchar](15) NULL,
	[Balance] [nvarchar](15) NULL,
	[Name_Description] [nvarchar](41) NULL,
	[Address_Memo] [nvarchar](41) NULL
) ON [PRIMARY]
END

USE [WA]
GO
/****** Object:  Table [dbo].[tblEMSMonthlyBalances]    Script Date: 10/06/2010 14:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEMSMonthlyBalances]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblEMSMonthlyBalances](
	[SubAccount] [nvarchar](16) NULL,
	[RegisterID] [nvarchar](10) NULL,
	[SSN] [nvarchar](9) NULL,
	[Name] [nvarchar](41) NULL,
	[OpenDate] [nvarchar](10) NULL,
	[CurrentBalance] [nvarchar](15) NULL,
	[AccruedInt] [nvarchar](13) NULL,
	[AccruedWhld] [nvarchar](13) NULL,
	[Rate] [nvarchar](6) NULL,
	[YTDInterest] [nvarchar](13) NULL,
	[YTDWhld] [nvarchar](13) NULL
) ON [PRIMARY]
END