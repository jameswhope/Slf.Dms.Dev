/****** Object:  Table [dbo].[tblScanRelation]    Script Date: 11/19/2007 11:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblScanRelation](
	[ScanRelationID] [int] IDENTITY(1,1) NOT NULL,
	[RelationType] [nvarchar](50) NOT NULL,
	[DocumentTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
