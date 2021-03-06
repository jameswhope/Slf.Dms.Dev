/****** Object:  Table [dbo].[tblAttorney_Old]    Script Date: 11/19/2007 11:02:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAttorney_Old](
	[AttorneyID] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[StateId] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[Suffix] [nvarchar](50) NULL,
	[UserID] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL
) ON [PRIMARY]
GO
