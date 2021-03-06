/****** Object:  Table [dbo].[tblTaskPropagationException]    Script Date: 11/19/2007 11:04:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTaskPropagationException](
	[TaskPropagationExceptionID] [int] IDENTITY(1,1) NOT NULL,
	[ClientID] [int] NOT NULL,
	[TaskPropagationID] [int] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblTaskPropagationException] PRIMARY KEY CLUSTERED 
(
	[TaskPropagationExceptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
