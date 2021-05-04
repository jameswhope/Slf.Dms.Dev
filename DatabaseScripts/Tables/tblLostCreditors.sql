/****** Object:  Table [dbo].[tblLostCreditors]    Script Date: 11/19/2007 11:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLostCreditors](
	[ClientID] [int] NULL,
	[AccountID] [int] NULL,
	[EightPct] [money] NULL,
	[AccountNo] [nvarchar](50) NULL,
	[Creditor] [nvarchar](255) NULL,
	[DebitAmount] [money] NULL
) ON [PRIMARY]
GO
