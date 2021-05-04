/****** Object:  Table [dbo].[tblMatterStatus]    Script Date: 02/24/2010 07:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblMatterStatus](
	[MatterStatusId] [int] NOT NULL,
	[MatterStatus] [varchar](50) NULL,
	[MatterStatusDescr] [varchar](100) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[lastModified] [datetime] NULL,
	[lastModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblMatterStatus] PRIMARY KEY CLUSTERED 
(
	[MatterStatusId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]