/****** Object:  Table [dbo].[tblStatementCreditor]    Script Date: 11/19/2007 11:04:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblStatementCreditor](
	[Acct_No] [nvarchar](255) NULL,
	[Cred_Name] [nvarchar](255) NULL,
	[Orig_Acct_No] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Balance] [money] NULL
) ON [PRIMARY]
GO
