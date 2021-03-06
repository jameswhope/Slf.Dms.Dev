
/****** Object:  Table [dbo].[tblMatterTask]    Script Date: 02/24/2010 09:27:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblMatterTask](
	[MatterTaskId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NULL,
	[TaskId] [int] NULL,
	[CreatedDatetime] [datetime] NULL,
	[CreatedBy] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tblMatterTask] PRIMARY KEY CLUSTERED 
(
	[MatterTaskId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblMatterTask]  WITH CHECK ADD  CONSTRAINT [FK_tblMatterTask_tblMatter] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblMatter] ([MatterId])
GO
ALTER TABLE [dbo].[tblMatterTask] CHECK CONSTRAINT [FK_tblMatterTask_tblMatter]
GO
ALTER TABLE [dbo].[tblMatterTask]  WITH CHECK ADD  CONSTRAINT [FK_tblMatterTask_tblTask] FOREIGN KEY([TaskId])
REFERENCES [dbo].[tblTask] ([TaskID])
GO
ALTER TABLE [dbo].[tblMatterTask] CHECK CONSTRAINT [FK_tblMatterTask_tblTask]