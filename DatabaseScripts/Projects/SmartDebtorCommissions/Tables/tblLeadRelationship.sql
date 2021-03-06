USE [RESTORED_3]
GO
/****** Object:  Table [dbo].[tblLeadRelationship]    Script Date: 06/25/2009 08:43:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLeadRelationship](
	[LeadRelationshipID] [int] IDENTITY(1,1) NOT NULL,
	[LeadCommissionID] [int] NOT NULL,
	[LeadSourceID] [int] NULL,
	[LeadSourcesIDs] [nvarchar](150) NULL,
	[LeadUserID] [int] NOT NULL,
	[LeadGroupID] [int] NULL,
 CONSTRAINT [PK_tblLeadCommishRelationship] PRIMARY KEY CLUSTERED 
(
	[LeadRelationshipID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
