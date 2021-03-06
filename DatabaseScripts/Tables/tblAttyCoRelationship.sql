/****** Object:  Table [dbo].[tblAttyCoRelationship]    Script Date: 11/19/2007 11:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAttyCoRelationship](
	[AttyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AttyRelationship] [nvarchar](75) NOT NULL,
 CONSTRAINT [PK_tblAttyCoRelationship] PRIMARY KEY CLUSTERED 
(
	[AttyTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
