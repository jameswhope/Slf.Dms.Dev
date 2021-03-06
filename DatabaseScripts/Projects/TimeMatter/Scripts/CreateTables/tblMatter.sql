USE [DMS_Test]
GO
/****** Object:  Table [dbo].[tblMatter]    Script Date: 02/24/2010 08:41:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMatter](
	[MatterId] [int] IDENTITY(1,1) NOT NULL,
	[MatterTypeId] [int] NULL,
	[ClientId] [int] NOT NULL,
	[MatterStatusCodeId] [int] NOT NULL,
	[MatterNumber] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MatterDate] [datetime] NULL,
	[MatterMemo] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreditorInstanceId] [int] NULL,
	[AttorneyId] [int] NULL,
	[ActiveFlag] [bit] NOT NULL CONSTRAINT [DF__tblMatter__Activ__76026BA8]  DEFAULT ((1)),
	[IsDeleted] [bit] NULL,
	[MatterStatusId] [int] NULL,
	[MatterSubStatusId] [int] NULL,
 CONSTRAINT [PK_tblMatter_1] PRIMARY KEY CLUSTERED 
(
	[MatterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblMatter]  WITH CHECK ADD  CONSTRAINT [FK_tblMatter_tblClient] FOREIGN KEY([ClientId])
REFERENCES [dbo].[tblClient] ([ClientID])
GO
ALTER TABLE [dbo].[tblMatter] CHECK CONSTRAINT [FK_tblMatter_tblClient]
GO
ALTER TABLE [dbo].[tblMatter]  WITH CHECK ADD  CONSTRAINT [FK_tblMatter_tblMatterStatusCode] FOREIGN KEY([MatterStatusCodeId])
REFERENCES [dbo].[tblMatterStatusCode] ([MatterStatusCodeId])
GO
ALTER TABLE [dbo].[tblMatter] CHECK CONSTRAINT [FK_tblMatter_tblMatterStatusCode]