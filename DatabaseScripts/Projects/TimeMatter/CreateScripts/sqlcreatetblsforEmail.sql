 --*** add tables for Email functionalities  ***
--*** Revision 1 1/26/2010					***
--*** 1. add tblEmailConfiguration			***
--*** 2. add tblEmailRelayLog				***

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailConfiguration]') AND type in (N'U'))

BEGIN
/****** Object:  Table [dbo].[tblEmailConfiguration]    Script Date: 01/26/2010 09:13:07 ******/

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
 CONSTRAINT [PK_tblEmailConfiguration] PRIMARY KEY CLUSTERED 
(
	[EmailConfigID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblEmailRelayLog]') AND type in (N'U'))

BEGIN

/****** Object:  Table [dbo].[tblEmailRelayLog]    Script Date: 01/26/2010 09:15:19 ******/
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
 CONSTRAINT [PK_tblEmailRelayLog] PRIMARY KEY CLUSTERED 
(
	[EMailLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

END
