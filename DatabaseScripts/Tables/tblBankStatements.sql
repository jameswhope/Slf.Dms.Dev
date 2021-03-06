/****** Object:  Table [dbo].[tblBankStatements]    Script Date: 11/19/2007 11:02:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBankStatements](
	[ItemNo] [int] IDENTITY(1,1) NOT NULL,
	[StatementYear] [int] NULL,
	[TransactionID] [nvarchar](50) NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionAmount] [money] NULL,
	[TransactionType] [nvarchar](255) NULL,
	[LastUpdated] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[TransactionFlag] [nvarchar](10) NULL,
	[CAccountNo] [nvarchar](50) NULL,
	[ClientName] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
