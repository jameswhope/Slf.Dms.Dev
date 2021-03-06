IF EXISTS (    SELECT 1 FROM INFORMATION_SCHEMA.TABLES     WHERE TABLE_NAME = 'tblLeadAudit' AND TABLE_SCHEMA = 'dbo')
	DROP TABLE tblLeadAudit 
GO
/****** Object:  Table [dbo].[tblLeadAudit]    Script Date: 01/22/2009 16:46:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLeadAudit](
	[UserName] [nvarchar](128) NULL,
	[TableName] [nvarchar](50) NULL,
	[FieldName] [nvarchar](75) NULL,
	[ModificationType] [nvarchar](50) NULL,
	[OldValue] [nvarchar](255) NULL,
	[NewValue] [nvarchar](255) NULL,
	[ModificationDate] [datetime] NULL,
	[TableIDValue] [nvarchar](50) NULL
) ON [PRIMARY]
