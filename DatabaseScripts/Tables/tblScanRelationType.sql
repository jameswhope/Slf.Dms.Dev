/****** Object:  Table [dbo].[tblScanRelationType]    Script Date: 11/19/2007 11:04:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblScanRelationType](
	[ScanRelationTypeID] [int] NOT NULL,
	[RelationType] [nvarchar](50) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[DocFolderIDs] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
