IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblBankUpload')
	BEGIN
		DROP  Table tblBankUpload
	END
GO

CREATE TABLE [dbo].[tblBankUpload](
	[BankUploadId] [int] IDENTITY(1,1) NOT NULL,
	[UploadedDate] [datetime] NOT NULL,
	[UploadedBy] [int] NOT NULL,
	[Processed] [bit] NOT NULL CONSTRAINT [DF_tblBankUpload_Processed]  DEFAULT ((0)),
	[ProcessedBy] [int] NULL,
	[ProcessedDate] [datetime] NULL,
	[BankAccountName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblBankUpload] PRIMARY KEY CLUSTERED 
(
	[BankUploadId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/*
GRANT SELECT ON Table_Name TO PUBLIC

GO
*/
