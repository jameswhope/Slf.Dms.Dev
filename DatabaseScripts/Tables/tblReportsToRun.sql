/****** Object:  Table [dbo].[tblReportsToRun]    Script Date: 11/19/2007 11:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblReportsToRun](
	[ReportNo] [int] NOT NULL,
	[LastModBy] [nvarchar](50) NOT NULL,
	[LastModDate] [datetime] NOT NULL,
	[Server_Database] [nvarchar](200) NULL,
	[Connection_String] [nvarchar](250) NOT NULL,
	[SQLLogin] [nvarchar](50) NOT NULL,
	[SQLPassword] [nvarchar](50) NOT NULL,
	[FTP_URL] [nvarchar](250) NULL,
	[FTPLogin] [nvarchar](50) NULL,
	[FTPPassword] [nvarchar](50) NULL,
	[Batch_Name] [nvarchar](50) NOT NULL,
	[Personal_Date] [nvarchar](1) NULL,
	[Creditor_Date] [nvarchar](1) NULL,
	[Transact_Date] [nvarchar](1) NULL,
	[Comments] [text] NULL,
	[Status] [nvarchar](50) NULL,
	[FolderPath] [nvarchar](250) NULL,
	[Message] [text] NULL,
	[Notes] [text] NULL,
	[ProcedureName] [varchar](50) NULL,
	[LastRunDate] [datetime] NULL,
	[LastRunLog] [text] NULL,
	[RunEvery] [varchar](10) NULL,
	[RunStartTime] [datetime] NULL,
	[RunStartDate] [datetime] NULL,
	[RptStart_Date] [datetime] NULL,
	[RptEnd_Date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
