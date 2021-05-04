/****** Object:  Table [dbo].[__tblVoidStuff]    Script Date: 11/19/2007 11:02:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__tblVoidStuff](
	[ClientID] [int] NOT NULL,
	[RegisterID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[EntryTypeID] [int] NOT NULL,
	[Fixed] [bit] NOT NULL CONSTRAINT [DF___tblVoidStuff_Fixed]  DEFAULT ((0))
) ON [PRIMARY]
GO
