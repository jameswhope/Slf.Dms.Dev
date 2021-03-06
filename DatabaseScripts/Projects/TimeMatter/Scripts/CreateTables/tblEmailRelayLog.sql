
GO
/****** Object:  Table [dbo].[tblEmailRelayLog]    Script Date: 02/22/2010 17:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblEmailRelayLog](
	[EMailLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[FromMailID] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToMailID] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CCMailID] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BCCMailID] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailSubject] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailMessage] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[Attachment] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MailFooter] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientID] [int] NULL,
	[UserGroupID] [int] NULL,
 CONSTRAINT [PK_tblEmailRelayLog] PRIMARY KEY CLUSTERED 
(
	[EMailLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF