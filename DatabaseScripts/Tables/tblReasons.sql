/****** Object:  Table [dbo].[tblReasons]    Script Date: 11/19/2007 11:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReasons](
	[ReasonsID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [int] NOT NULL,
	[ValueType] [nvarchar](50) NOT NULL,
	[ReasonsDescID] [nchar](10) NOT NULL,
	[Other] [nvarchar](255) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL
) ON [PRIMARY]
GO
