
-- Definition :	 SQL Script for schema changes and update to accomodate matter information
-- Revision   :  0 ~ 11/30/2009
-- Summary	  :  New Tables: 1. tblMatter for Matter information
--							 2. tblMatterStatusCode for Status of Matter 
--							 3. tblMatterTask  for relationship of matter and Tasks 


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblMatterStatusCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblMatterStatusCode](
	[MatterStatusCodeId] [int] IDENTITY(1,1) NOT NULL,
	[MatterStatusCode] [varchar](50) NULL,
	[MatterStatusCodeDescr] [varchar](100) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[lastModified] [datetime] NULL,
	[lastModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblMatterStatusCode] PRIMARY KEY CLUSTERED 
(
	[MatterStatusCodeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblMatterTask]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblMatterTask](
	[MatterTaskId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NULL,
	[TaskId] [int] NULL,
	[CreatedDatetime] [datetime] NULL,
	[CreatedBy] [nchar](10) NULL,
 CONSTRAINT [PK_tblMatterTask] PRIMARY KEY CLUSTERED 
(
	[MatterTaskId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblMatter]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblMatter](
	[MatterId] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [int] NOT NULL,
	[MatterStatusCodeId] [int] NOT NULL,
	[MatterNumber] [varchar](50) NOT NULL,
	[MatterDate] [datetime] NULL,
	[MatterMemo] [varchar](200) NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreditorInstanceId] [int] NULL,
	[AttorneyId] [int] NULL,
 CONSTRAINT [PK_tblMatter_1] PRIMARY KEY CLUSTERED 
(
	[MatterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblMatterTask_tblMatter]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblMatterTask]'))
ALTER TABLE [dbo].[tblMatterTask]  WITH CHECK ADD  CONSTRAINT [FK_tblMatterTask_tblMatter] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblMatter] ([MatterId])
GO
ALTER TABLE [dbo].[tblMatterTask] CHECK CONSTRAINT [FK_tblMatterTask_tblMatter]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblMatterTask_tblTask]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblMatterTask]'))
ALTER TABLE [dbo].[tblMatterTask]  WITH CHECK ADD  CONSTRAINT [FK_tblMatterTask_tblTask] FOREIGN KEY([TaskId])
REFERENCES [dbo].[tblTask] ([TaskID])
GO
ALTER TABLE [dbo].[tblMatterTask] CHECK CONSTRAINT [FK_tblMatterTask_tblTask]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblMatter_tblClient]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblMatter]'))
ALTER TABLE [dbo].[tblMatter]  WITH CHECK ADD  CONSTRAINT [FK_tblMatter_tblClient] FOREIGN KEY([ClientId])
REFERENCES [dbo].[tblClient] ([ClientID])
GO
ALTER TABLE [dbo].[tblMatter] CHECK CONSTRAINT [FK_tblMatter_tblClient]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tblMatter_tblMatterStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tblMatter]'))
ALTER TABLE [dbo].[tblMatter]  WITH CHECK ADD  CONSTRAINT [FK_tblMatter_tblMatterStatusCode] FOREIGN KEY([MatterStatusCodeId])
REFERENCES [dbo].[tblMatterStatusCode] ([MatterStatusCodeId])
GO
ALTER TABLE [dbo].[tblMatter] CHECK CONSTRAINT [FK_tblMatter_tblMatterStatusCode]
