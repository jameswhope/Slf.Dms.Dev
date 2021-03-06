/****** Object:  Table [dbo].[tblReasonsDesc_old]    Script Date: 11/19/2007 11:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReasonsDesc_old](
	[ReasonsDescID] [int] NOT NULL,
	[DisplayOrder] [int] NULL,
	[Description] [nvarchar](100) NULL,
	[Type] [nvarchar](100) NULL,
	[ClientID] [int] NULL,
	[AccountNumber] [int] NULL,
	[CompanyID] [int] NULL,
	[AgencyID] [int] NULL,
	[AgentID] [int] NULL,
	[AttorneyID] [int] NULL,
	[EmployeeID] [int] NULL,
	[ParentReasonsDescID] [int] NULL
) ON [PRIMARY]
GO
