/****** Object:  Table [dbo].[tblTask]    Script Date: 11/19/2007 11:04:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTask](
	[TaskID] [int] IDENTITY(1,1) NOT NULL,
	[ParentTaskID] [int] NULL,
	[TaskTypeID] [int] NULL,
	[Description] [varchar](500) NOT NULL,
	[AssignedTo] [int] NOT NULL,
	[Due] [datetime] NOT NULL,
	[Resolved] [datetime] NULL,
	[ResolvedBy] [int] NULL,
	[TaskResolutionID] [int] NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblTask] PRIMARY KEY CLUSTERED 
(
	[TaskID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
