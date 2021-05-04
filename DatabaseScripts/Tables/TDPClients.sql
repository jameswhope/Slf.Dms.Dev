/****** Object:  Table [dbo].[TDPClients]    Script Date: 11/19/2007 11:04:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TDPClients](
	[agency] [nvarchar](255) NULL,
	[agentid] [float] NULL,
	[clientid] [float] NULL,
	[transpfoid] [datetime] NULL,
	[transdate] [datetime] NULL,
	[amount] [float] NULL,
	[description] [nvarchar](255) NULL
) ON [PRIMARY]
GO
