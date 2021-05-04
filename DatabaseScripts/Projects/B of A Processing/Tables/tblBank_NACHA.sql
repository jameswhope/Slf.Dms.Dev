IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblBank_NACHA')
	BEGIN
		DROP  Table tblBank_NACHA
	END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblBank_NACHA](
	[NACHABankID] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [nvarchar](50) NULL,
	[ImmediateDestination] [nvarchar](50) NULL,
	[ImmediateDestinationName] [nvarchar](23) NULL,
	[OriginatingDFI] [nvarchar](8) NULL,
	[ImmediateOrigin] [nvarchar](23) NULL,
	[ImmediateOriginName] [nvarchar](23) NULL,
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
	[BankPublicKeyName] [nvarchar](50) NULL,
	[LastModified] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[PPDBatchID] [nchar](10) NULL,
	[CCDBatchID] [nchar](10) NULL,
	[NACHACompanyName] [nvarchar](15) NULL,
	[BankClientID] [nchar](10) NULL,
	[OriginContactPhoneNumber] [varchar](10) NULL,
	[OriginContactName] [varchar](14) NULL,
	[MasterAccountNo] [nvarchar](50) NULL,
	[NewFileLocation] [nvarchar](250) NULL,
	[CkFileLocation] [nvarchar](250) NULL,
	[BAFFFileLocation] [nvarchar](250) NULL,
	[BAFFUserName] [nvarchar](50) NULL,
	[BAFFPassword] [nvarchar](50) NULL,
	[BAFFFolder] [nvarchar](250) NULL,
	[BAFFUserNameIn] [nvarchar](50) NULL,
	[BAFFPasswordIn] [nvarchar](50) NULL,
	[NACHAUserNameIn] [nvarchar](50) NULL,
	[NACHAPasswordIn] [nvarchar](50) NULL,
	[ICLFileLocation] [nvarchar](250) NULL,
	[BAFFABA] [nvarchar](250) NULL,
	[BAFFOriginator] [nvarchar](250) NULL,
	[M2MFileLocation] [nvarchar](250) NULL,
	[M2MUserNameIn] [nvarchar](250) NULL,
	[M2MPasswordIn] [nvarchar](250) NULL,
	[ICLImmediateOrigin] [nvarchar](250) NULL,
	[ICLOriginContactPhoneNumber] [nvarchar](50) NULL,
	[ICLContactname] [nvarchar](50) NULL,
	[ICLConnectionString] [nvarchar](250) NULL,
	[ICLftpControlPort] [nvarchar](50) NULL,
	[ICLftpFolder] [nvarchar](50) NULL,
	[ICLUserName] [nvarchar](50) NULL,
	[ICLftpPassword] [nvarchar](50) NULL,
	[ICLLogPath] [nvarchar](250) NULL,
	[ICLLogFile] [nvarchar](250) NULL,
	[ICLBankClientID] [nvarchar](250) NULL,
	[ICLCustomerID] [nvarchar](250) NULL,
	[ICLInputFileTransmissionID] [nvarchar](250) NULL,
	[ICLReceiptAckTransmissionID] [nvarchar](250) NULL,
	[ICLAdjustmentAckTransmission] [nvarchar](250) NULL,
	[ICLLocationName] [nvarchar](250) NULL,
	[ICLAccountNumber] [nvarchar](250) NULL,
 CONSTRAINT [PK_tblBank_NACHA] PRIMARY KEY CLUSTERED 
(
	[NACHABankID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
GRANT SELECT ON tblBank_NACHA TO PUBLIC

GO
*/

SET ANSI_PADDING OFF