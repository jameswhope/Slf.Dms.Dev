/****** Object:  Table [dbo].[tblPermission]    Script Date: 11/19/2007 11:04:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPermission](
	[PermissionId] [int] IDENTITY(1,1) NOT NULL,
	[PermissionTypeId] [int] NOT NULL,
	[Value] [bit] NULL,
	[FunctionId] [int] NOT NULL,
 CONSTRAINT [PK_tblPermission2] PRIMARY KEY CLUSTERED 
(
	[PermissionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
