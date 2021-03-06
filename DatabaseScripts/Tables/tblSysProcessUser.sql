/****** Object:  Table [dbo].[tblSysProcessUser]    Script Date: 11/19/2007 11:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSysProcessUser](
	[SysProcessUserID] [int] IDENTITY(1,1) NOT NULL,
	[SPID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK_tblSysProcessUser] PRIMARY KEY CLUSTERED 
(
	[SysProcessUserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
