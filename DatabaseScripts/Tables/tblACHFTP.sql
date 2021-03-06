/****** Object:  Table [dbo].[tblACHFTP]    Script Date: 11/19/2007 11:02:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblACHFTP](
	[ACH_ID] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[BankName] [nvarchar](100) NULL,
	[Destination] [int] NULL,
	[Origin] [int] NULL,
	[OriginName] [nvarchar](50) NULL,
	[FTPServer] [nvarchar](100) NULL,
	[FTPLogin] [nvarchar](50) NULL,
	[FTPPassword] [nvarchar](50) NULL,
	[FTPFolder] [nvarchar](50) NULL,
	[FTPURL] [nvarchar](200) NULL,
	[FTPPort] [int] NULL,
	[LogPath] [nvarchar](150) NULL,
	[FileLocation] [nvarchar](150) NULL,
	[DataProvider] [nvarchar](50) NULL,
	[LogFile] [nvarchar](50) NULL,
	[LogEmailTo] [nvarchar](75) NULL,
	[smtpServer] [nvarchar](100) NULL,
	[ConnectionString] [nvarchar](100) NULL,
	[Encrypt] [bit] NULL,
	[EncryptKey] [nvarchar](3000) NULL,
	[CreateFile] [bit] NULL,
 CONSTRAINT [PK_tblACHFTP] PRIMARY KEY CLUSTERED 
(
	[ACH_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
