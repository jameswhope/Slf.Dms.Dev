/****** Object:  Table [dbo].[tblNACHARoot]    Script Date: 11/19/2007 11:03:59 ******/
/*
CREATE TABLE [dbo].[tblNACHARoot](
	[tblNACHARoot] [int] IDENTITY(1,1) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[CommRecID] [nvarchar](15) NULL,
	[Bank] [nvarchar](23) NULL,
	[DestinationRoutingNo] [nvarchar](50) NULL,
	[OriginTaxID] [nvarchar](25) NULL,
	[OriginName] [nvarchar](23) NULL,
	[ConnectionString] [nvarchar](250) NULL,
	[ftpServer] [nvarchar](100) NULL,
	[ftpControlPort] [int] NULL,
	[ftpUpload] [bit] NOT NULL,
	[ftpFolder] [nvarchar](250) NULL,
	[ftpUserName] [nvarchar](50) NULL,
	[ftpPassword] [nvarchar](50) NULL,
	[Passphrase] [nvarchar](50) NULL,
	[CreateFile] [bit] NOT NULL,
	[GPGDir] [nvarchar](100) NULL,
	[PublicKeyRing] [nvarchar](250) NULL,
	[PrivateKeyring] [nvarchar](250) NULL,
	[FileLocation] [nvarchar](250) NULL,
	[LogPath] [nvarchar](250) NULL,
	[LogFile] [nvarchar](50) NULL,
	[DataProvider] [nvarchar](50) NULL,
	[LogMailTo] [nvarchar](50) NULL,
	[SMTPServer] [nvarchar](50) NULL,
	[Encrypt] [bit] NULL,
	[BlackBoxKey] [nvarchar](max) NULL,
	[OperatingAcct] [nvarchar](50) NULL,
	[ClearingAcct] [nvarchar](50) NULL,
	[GenClearing] [nvarchar](50) NULL,
	[IOLTATrust] [nvarchar](50) NULL,
	[LastModified] [datetime] NULL,
	[ModifiedByUserNo] [int] NULL
) ON [PRIMARY]
*/

/*
	11/30/07	jhernandez	
*/
if not exists (select 1 from syscolumns where id = object_id('tblNachaRoot') and name = 'Created') begin
	alter table tblNachaRoot add Created datetime default(getdate())
end

if not exists (select 1 from syscolumns where id = object_id('tblNachaRoot') and name = 'CreatedBy') begin
	alter table tblNachaRoot add CreatedBy int
end