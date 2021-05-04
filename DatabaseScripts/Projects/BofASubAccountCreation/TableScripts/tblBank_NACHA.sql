IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblBank_NACHA')
	BEGIN
		DROP  Table tblBank_NACHA
	END
GO
/****** Object:  Table [dbo].[tblBank_NACHA]    Script Date: 11/13/2009 16:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBank_NACHA](
	[NACHABankID] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [nvarchar](50) NULL,
	[ImemediateDestination] [varchar](50) NULL,
	[Destination] [nvarchar](23) NULL,
	[ServiceClassCode] [nvarchar](50) NULL,
	[CompanyIdentification] [nvarchar](50) NULL,
	[OriginatingDFI] [nvarchar](8) NULL,
	[DestinationRoutingNo] [nvarchar](50) NULL,
	[DestinationAccountNo] [nvarchar](50) NULL,
	[MasterRoutingNo] [nvarchar](9) NULL,
	[OriginTaxID] [nvarchar](23) NULL,
	[OriginName] [nvarchar](23) NULL,
	[ConnectionString] [nvarchar](250) NULL,
	[ftpServer] [nvarchar](100) NULL,
	[ftpControlPort] [int] NULL,
	[ftpUpload] [bit] NULL,
	[ftpFolder] [nvarchar](250) NULL,
	[ftpUserName] [nvarchar](50) NULL,
	[ftpPassword] [nvarchar](50) NULL,
	[Passphrase] [nvarchar](50) NULL,
	[CreateFile] [bit] NULL,
	[GPGDir] [nvarchar](100) NULL,
	[PublicKeyRing] [nvarchar](max) NULL,
	[PrivateKeyRing] [nvarchar](max) NULL,
	[FileLocation] [nvarchar](250) NULL,
	[LogPath] [nvarchar](250) NULL,
	[LogFile] [nvarchar](50) NULL,
	[DataProvider] [nvarchar](50) NULL,
	[LogMailTo] [nvarchar](50) NULL,
	[SMTPServer] [nvarchar](50) NULL,
	[Encrypt] [bit] NULL,
	[BlackBoxKey] [nvarchar](max) NULL,
	[MasterAccountNo] [nvarchar](50) NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblBank_NACHA] PRIMARY KEY CLUSTERED 
(
	[NACHABankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

