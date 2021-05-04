USE [DMS_Test]
GO
/****** Object:  Table [dbo].[tblMatterAudit]    Script Date: 02/24/2010 07:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMatterAudit](
	[Type] [char](1) NULL,
	[TableName] [varchar](128) NULL,
	[PK] [varchar](1000) NULL,
	[FieldName] [varchar](128) NULL,
	[OldValue] [varchar](1000) NULL,
	[NewValue] [varchar](1000) NULL,
	[UpdateDate] [datetime] NULL,
	[UserName] [varchar](128) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
