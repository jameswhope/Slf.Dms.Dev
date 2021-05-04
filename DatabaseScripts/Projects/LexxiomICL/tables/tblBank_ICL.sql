IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblBank_ICL')
	BEGIN
		CREATE TABLE [tblBank_ICL](
			[ICLBankID] [int] NOT NULL,
			[BankName] [nvarchar](50) NULL,
			[ImmediateDestination] [nvarchar](50) NULL,
			[ImmediateDestinationName] [nvarchar](23) NULL,
			[ImmediateOrigin] [nvarchar](23) NULL,
			[ImmediateOriginName] [nvarchar](23) NULL,
			[OriginContactPhoneNumber] [varchar](10) NULL,
			[OriginContactName] [varchar](14) NULL,
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
			[LastModified] [datetime] NULL,
			[LastModifiedBy] [int] NULL,
			[BankClientID] [nchar](10) NULL,
			[ICLCustomerID] [varchar](50) NULL,
			[ICLInputFileTransmissionID] [varchar](50) NULL,
			[ICLReceiptAckTransmissionID] [varchar](50) NULL,
			[ICLAdjustmentAckTransmissionID] [varchar](50) NULL,
			[ICLLocationName] [varchar](100) NULL,
			[ICLAccountNumber] [varchar](50) NULL
		) ON [PRIMARY]
	END
GO






