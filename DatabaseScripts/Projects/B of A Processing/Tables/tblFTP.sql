USE [DMS]
GO
/****** Object:  Table [dbo].[tblFTP]    Script Date: 08/05/2010 08:43:45 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblFTP]') AND type in (N'U'))
BEGIN
	DROP TABLE [dbo].[tblFTP]
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblFTP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tblFTP](
	[FTPID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NULL,
	[BankID] [int] NULL,
	[BankPubKeyName] [nvarchar](50) NULL,
	[BlackBoxKey] [nvarchar](1000) NULL,
	[FTPUpFileType] [nvarchar](50) NULL,
	[FTPUpServer] [nvarchar](100) NULL,
	[FTPUpPort] [nvarchar](8) NULL,
	[FTPUpFolder] [nvarchar](50) NULL,
	[FTPUpLogin] [nvarchar](50) NULL,
	[FTPUpPwd] [nvarchar](50) NULL,
	[FTPUpPassphrase] [nvarchar](50) NULL,
	[FTPUpPGPTo] [nvarchar](50) NULL,
	[FTPUpRawFileLocation] [nvarchar](150) NULL,
	[FTPDnFileType] [nvarchar](50) NULL,
	[FTPDnServer] [nvarchar](50) NULL,
	[FTPDnPort] [nvarchar](8) NULL,
	[FTPDnFolder] [nvarchar](50) NULL,
	[FTPDnLogin] [nvarchar](50) NULL,
	[FTPDnPwd] [nvarchar](50) NULL,
	[FTPDnPassphrase] [nvarchar](50) NULL,
	[FTPDnPGPTo] [nvarchar](50) NULL,
	[FTPDnRawFileLocation] [nvarchar](150) NULL,
	[ImmediateOrigin] [nvarchar](50) NULL,
	[ImmediateOriginName] [nvarchar](50) NULL,
	[ImmediateDestination] [nvarchar](50) NULL,
	[ImmediateDestName] [nvarchar](50) NULL,
	[NACHALogFile] [nvarchar](50) NULL,
	[MasterAccount] [nvarchar](50) NULL,
	[CompanyName] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblFTP] PRIMARY KEY CLUSTERED 
(
	[FTPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
END