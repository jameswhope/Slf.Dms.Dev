/****** Object:  Table [dbo].[tblRelationType]    Script Date: 11/19/2007 11:04:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRelationType](
	[RelationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Table] [varchar](50) NOT NULL,
	[KeyField] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[IconURL] [varchar](200) NOT NULL,
	[NavigateURL] [varchar](200) NOT NULL,
	[DocRelation] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblRelationType] PRIMARY KEY CLUSTERED 
(
	[RelationTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
