/****** Object:  Table [dbo].[tblCompanyAttyPivot]    Script Date: 11/19/2007 11:03:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyAttyPivot](
	[PivotID] [int] IDENTITY(1,1) NOT NULL,
	[AttorneyID] [int] NULL,
	[CompanyID] [int] NULL,
	[AttyRelationship] [int] NULL,
 CONSTRAINT [PK_tblCompanyAttyPivot] PRIMARY KEY CLUSTERED 
(
	[PivotID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
