/****** Object:  Table [dbo].[tblStatementResults-old]    Script Date: 11/19/2007 11:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStatementResults-old](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NULL,
	[AccountNumber] [varchar](50) NULL,
	[Date] [datetime] NULL,
	[Type] [varchar](50) NULL,
	[Description] [varchar](255) NULL,
	[Amount] [money] NULL,
	[SDABalance] [money] NULL,
	[PFOBalance] [money] NULL,
	[order] [int] NULL,
	[EntryTypeId] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
