/****** Object:  Table [dbo].[tblFunction]    Script Date: 11/19/2007 11:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblFunction](
	[FunctionId] [int] IDENTITY(1,1) NOT NULL,
	[ParentFunctionId] [int] NULL,
	[Name] [varchar](255) NOT NULL,
	[FullName] [varchar](255) NULL,
	[Description] [varchar](255) NULL,
	[IsSystem] [bit] NOT NULL CONSTRAINT [DF_tblFunction_IsSystem_671ebf8047574c5e999fd941e543edee]  DEFAULT (0),
	[IsOperation] [bit] NOT NULL CONSTRAINT [DF_tblFunction_IsOperation_671ebf8047574c5e999fd941e543edee]  DEFAULT (0),
 CONSTRAINT [PK_tblFunction_671ebf8047574c5e999fd941e543edee] PRIMARY KEY CLUSTERED 
(
	[FunctionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
