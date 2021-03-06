/****** Object:  Table [dbo].[tblProperty]    Script Date: 11/19/2007 11:04:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblProperty](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyCategoryID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Display] [varchar](50) NOT NULL,
	[Nullable] [bit] NOT NULL CONSTRAINT [DF_tblProperty_Nullable]  DEFAULT (0),
	[Length] [int] NULL,
	[Multi] [bit] NOT NULL CONSTRAINT [DF_tblProperty_Multi]  DEFAULT (0),
	[Value] [varchar](1000) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblProperty] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
