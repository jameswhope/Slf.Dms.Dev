CREATE TABLE [dbo].[tblHarassmentEmailTemplates](
	[HarassmentEmailID] [int] IDENTITY(1,1) NOT NULL,
	[EmailTemplateText] [ntext] NOT NULL,
	[Type] [varchar](50) NULL,
	[Seq] [int] NULL,
	[Created] [datetime] NULL,
 CONSTRAINT [PK_tblHarassmentEmailTemplates] PRIMARY KEY CLUSTERED 
(
	[HarassmentEmailID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblHarassmentEmailTemplates] ADD  CONSTRAINT [DF_tblHarassmentEmailTemplates_Created]  DEFAULT (getdate()) FOR [Created]
GO

