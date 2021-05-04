/****** Object:  Table [dbo].[tblMatterType]    Script Date: 02/24/2010 07:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMatterType](
	[MatterTypeId] [int] IDENTITY(1,1) NOT NULL,
	[MatterTypeCode] [varchar](50) NOT NULL,
	[MatterTypeShortDescr] [varchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Created] [datetime] NULL,
	[Createdby] [int] NULL,
	[Lastmodified] [datetime] NULL,
	[Lastmodifiedby] [int] NULL,
 CONSTRAINT [PK_tblMatterType] PRIMARY KEY CLUSTERED 
(
	[MatterTypeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  ForeignKey [FK_tblMatterType_tblMatterType]    Script Date: 02/24/2010 07:11:14 ******/
ALTER TABLE [dbo].[tblMatterType]  WITH CHECK ADD  CONSTRAINT [FK_tblMatterType_tblMatterType] FOREIGN KEY([MatterTypeId])
REFERENCES [dbo].[tblMatterType] ([MatterTypeId])
GO
ALTER TABLE [dbo].[tblMatterType] CHECK CONSTRAINT [FK_tblMatterType_tblMatterType]
GO
