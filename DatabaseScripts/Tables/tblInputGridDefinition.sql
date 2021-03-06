/****** Object:  Table [dbo].[tblInputGridDefinition]    Script Date: 11/19/2007 11:03:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblInputGridDefinition](
	[InputGridID] [int] NOT NULL,
	[Col] [int] NOT NULL,
	[FieldName] [varchar](50) NOT NULL,
	[Required] [bit] NOT NULL,
	[DataType] [varchar](50) NOT NULL,
	[Length] [int] NULL,
 CONSTRAINT [PK_tblClientQueueDefinition] PRIMARY KEY CLUSTERED 
(
	[InputGridID] ASC,
	[Col] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
