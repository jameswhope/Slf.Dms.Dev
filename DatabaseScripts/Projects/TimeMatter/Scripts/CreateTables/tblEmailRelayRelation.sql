
GO
/****** Object:  Table [dbo].[tblEmailRelayRelation]    Script Date: 02/22/2010 17:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmailRelayRelation](
	[EmailRelayRelationID] [int] IDENTITY(1,1) NOT NULL,
	[EMailLogID] [int] NULL,
	[RelationTypeID] [int] NULL,
	[RelationID] [int] NULL,
 CONSTRAINT [PK_tblEmailRelayRelation] PRIMARY KEY CLUSTERED 
(
	[EmailRelayRelationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
