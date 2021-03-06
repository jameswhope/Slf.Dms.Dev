/****** Object:  Table [dbo].[tblTaskPropagation]    Script Date: 11/19/2007 11:04:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaskPropagation](
	[TaskPropagationID] [int] IDENTITY(1,1) NOT NULL,
	[TaskTypeID] [int] NOT NULL,
	[Order] [int] NOT NULL,
	[CanDelete] [bit] NOT NULL CONSTRAINT [DF_tblTaskPropagation_CanDelete]  DEFAULT (0),
	[CanEdit] [bit] NOT NULL CONSTRAINT [DF_tblTaskPropagation_CanEdit]  DEFAULT (0),
	[Type] [varchar](50) NOT NULL,
	[TypeID] [int] NOT NULL,
	[Due] [money] NULL,
	[AssignedToResolver] [bit] NOT NULL CONSTRAINT [DF_tblTaskPropagation_AssignedToResolver]  DEFAULT (0),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblTaskPropagation] PRIMARY KEY CLUSTERED 
(
	[TaskPropagationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
