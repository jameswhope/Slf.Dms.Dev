USE [ClientStatements]
GO
/****** Object:  Table [dbo].[tblStatementCreditor]    Script Date: 01/05/2011 08:33:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblStatementCreditor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblStatementCreditor](
	[Acct_No] [nvarchar](255) NULL,
	[Cred_Name] [nvarchar](255) NULL,
	[Orig_Acct_No] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Balance] [money] NULL,
	[StmtPeriod] [nvarchar](50) NULL
) ON [PRIMARY]
END