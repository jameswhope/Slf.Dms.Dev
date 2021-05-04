 USE [Payroll]
GO
/****** Object:  Table [dbo].[tblAuditLog]    Script Date: 01/11/2011 15:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblAuditLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblAuditLog](
	[AuditID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](50) NULL,
	[FieldName] [nvarchar](50) NULL,
	[ValueWas] [nvarchar](50) NULL,
	[ValueIs] [nvarchar](50) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL
) ON [PRIMARY]
END