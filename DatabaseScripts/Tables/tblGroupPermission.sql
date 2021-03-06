/****** Object:  Table [dbo].[tblGroupPermission]    Script Date: 11/19/2007 11:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGroupPermission](
	[GroupPermissionId] [int] IDENTITY(1,1) NOT NULL,
	[UserTypeId] [int] NULL,
	[UserGroupId] [int] NULL,
	[PermissionId] [int] NOT NULL,
 CONSTRAINT [PK_tblPosition2Control] PRIMARY KEY CLUSTERED 
(
	[GroupPermissionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
