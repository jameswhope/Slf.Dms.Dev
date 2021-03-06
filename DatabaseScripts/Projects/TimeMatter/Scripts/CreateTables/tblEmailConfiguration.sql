
/****** Object:  Table [dbo].[tblEmailConfiguration]    Script Date: 02/22/2010 17:40:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEmailConfiguration](
	[EmailConfigID] [bigint] IDENTITY(1,1) NOT NULL,
	[MailFrom] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailCC] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailBCC] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailSubject] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailPurpose] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailContent] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailFooter] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Createdby] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedby] [bigint] NULL,
	[LastModifiedDate] [datetime] NULL,
	[Status] [bit] NULL,
	[SeqNo] [int] NULL,
	[LawfirmId] [int] NULL,
 CONSTRAINT [PK_tblEmailConfiguration] PRIMARY KEY CLUSTERED 
(
	[EmailConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF