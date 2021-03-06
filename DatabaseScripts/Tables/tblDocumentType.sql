/****** Object:  Table [dbo].[tblDocumentType]    Script Date: 11/19/2007 11:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblDocumentType](
	[DocumentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TypeID] [nvarchar](50) NOT NULL,
	[TypeName] [varchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[DocFolder] [nvarchar](50) NOT NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
