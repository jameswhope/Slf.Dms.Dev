 USE [ClientStatements]
GO
/****** Object:  Table [dbo].[tblStatementPersonal]    Script Date: 01/05/2011 08:46:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblStatementPersonal]') AND type in (N'U'))
BEGIN
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
	[Payee] [varchar](160) NULL,
	[cslocation1] [nvarchar](150) NOT NULL,
	[cslocation2] [nvarchar](95) NOT NULL,
	[desc1] [nvarchar](15) NOT NULL,
	[desc2] [nvarchar](255) NULL,
	[desc3] [varchar](1) NOT NULL,
	[DepDate1] [nvarchar](50) NULL,
	[DepAmt1] [nvarchar](50) NULL,
	[DepDate2] [nvarchar](50) NULL,
	[DepAmt2] [nvarchar](50) NULL,
	[DepDate3] [nvarchar](50) NULL,
	[DepAmt3] [nvarchar](50) NULL,
	[DepDate4] [nvarchar](50) NULL,
	[DepAmt4] [nvarchar](50) NULL,
	[StmtPeriod] [varchar](50) NULL,
	[ElectronicStatements] [bit] NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF