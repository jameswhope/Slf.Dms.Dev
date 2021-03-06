/****** Object:  Table [dbo].[tblControl]    Script Date: 11/19/2007 11:03:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblControl](
	[ControlId] [int] IDENTITY(1,1) NOT NULL,
	[PageId] [int] NOT NULL,
	[ServerName] [nvarchar](255) NOT NULL,
	[PermissionTypeID] [int] NOT NULL CONSTRAINT [PermissionTypeID_default]  DEFAULT (1),
	[Action] [bit] NOT NULL CONSTRAINT [Action_default]  DEFAULT (0),
 CONSTRAINT [PK_tblControl] PRIMARY KEY CLUSTERED 
(
	[ControlId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
