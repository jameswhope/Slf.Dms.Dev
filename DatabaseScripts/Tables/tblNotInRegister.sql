/****** Object:  Table [dbo].[tblNotInRegister]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblNotInRegister](
	[FirmID] [int] NULL,
	[clientid] [int] NULL,
	[acctno] [int] NULL,
	[cname] [nvarchar](255) NULL,
	[depositmethod] [nvarchar](15) NULL,
	[depositday] [int] NULL,
	[SDABal] [decimal](18, 2) NULL,
	[RetFeeBal] [decimal](18, 2) NULL,
	[settfeebal] [decimal](18, 2) NULL,
	[maintfeebal] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
