/****** Object:  Table [dbo].[tblDocRelation]    Script Date: 11/19/2007 11:03:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDocRelation](
	[DocRelationID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[RelationID] [int] NOT NULL,
	[RelationType] [nvarchar](50) NOT NULL,
	[DocTypeID] [nvarchar](15) NOT NULL,
	[DocID] [nvarchar](15) NOT NULL,
	[DateString] [nvarchar](6) NOT NULL,
	[SubFolder] [nvarchar](150) NULL,
	[RelatedDate] [datetime] NOT NULL,
	[RelatedBy] [int] NOT NULL,
	[DeletedFlag] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [int] NULL
) ON [PRIMARY]
GO
