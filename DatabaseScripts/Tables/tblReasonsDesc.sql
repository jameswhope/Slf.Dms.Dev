/****** Object:  Table [dbo].[tblReasonsDesc]    Script Date: 11/19/2007 11:04:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReasonsDesc](
	[ReasonsDescID] [int] IDENTITY(1,1) NOT NULL,
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
	[ParentReasonsDescID] [int] NULL,
	[Deleted] [datetime] NULL,
	[DeleteBy] [int] NULL
) ON [PRIMARY]
GO
