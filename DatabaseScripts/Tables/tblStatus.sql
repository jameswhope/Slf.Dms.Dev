/****** Object:  Table [dbo].[tblStatus]    Script Date: 11/19/2007 11:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblStatus](
	[statusID] [int] IDENTITY(1,1) NOT NULL,
	[loggedOn] [bit] NOT NULL CONSTRAINT [DF_tblStatus_loggedOn]  DEFAULT ((0)),
	[ClientID] [int] NOT NULL,
	[UserStat] [char](10) NOT NULL,
	[DateTime] [smalldatetime] NULL,
	[IPAddress] [char](15) NULL,
	[optIn] [bit] NULL CONSTRAINT [DF_tblStatus_optIn]  DEFAULT ((0)),
 CONSTRAINT [PK_tblStatus] PRIMARY KEY CLUSTERED 
(
	[statusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
