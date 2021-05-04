/****** Object:  Table [dbo].[__tblAddStuff]    Script Date: 11/19/2007 11:02:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__tblAddStuff](
	[ClientID] [int] NOT NULL,
	[RegisterID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[EntryTypeID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Fixed] [bit] NOT NULL CONSTRAINT [DF___tblAddStuff_Fixed]  DEFAULT ((0))
) ON [PRIMARY]
GO
