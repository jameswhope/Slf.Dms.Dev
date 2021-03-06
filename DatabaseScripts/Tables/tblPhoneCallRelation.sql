/****** Object:  Table [dbo].[tblPhoneCallRelation]    Script Date: 11/19/2007 11:04:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPhoneCallRelation](
	[PhoneCallRelationID] [int] IDENTITY(1,1) NOT NULL,
	[PhoneCallID] [int] NOT NULL,
	[RelationTypeID] [int] NOT NULL,
	[RelationID] [int] NOT NULL,
 CONSTRAINT [PK_tblPhoneCallRelation] PRIMARY KEY CLUSTERED 
(
	[PhoneCallRelationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
