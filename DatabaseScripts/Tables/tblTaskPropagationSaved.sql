/****** Object:  Table [dbo].[tblTaskPropagationSaved]    Script Date: 11/19/2007 11:04:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTaskPropagationSaved](
	[TaskPropagationSavedID] [int] IDENTITY(1,1) NOT NULL,
	[TaskID] [int] NOT NULL,
	[AssignedTo] [int] NOT NULL,
	[DueType] [int] NOT NULL,
	[Due] [money] NULL,
	[Date] [datetime] NULL,
	[TaskTypeID] [int] NULL,
	[Description] [varchar](500) NULL,
 CONSTRAINT [PK_tblTaskPropagationSaved] PRIMARY KEY CLUSTERED 
(
	[TaskPropagationSavedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
