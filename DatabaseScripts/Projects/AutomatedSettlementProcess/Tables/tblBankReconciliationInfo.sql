IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblBankReconciliationInfo')
	BEGIN
		DROP  Table tblBankReconciliationInfo
	END
GO

CREATE TABLE [dbo].[tblBankReconciliationInfo](
	[Rejected] [bit] NOT NULL CONSTRAINT [DF_tblBankReconciliationInfo_Rejected]  DEFAULT ((0)),
	[BAICode] [int] NOT NULL,
	[Description] [varchar](50) NOT NULL,
	[Amount] [money] NOT NULL,
	[DataType] [varchar](10) NOT NULL,
	[CustomerRef] [int] NULL,
	[Reconciled] [bit] NOT NULL CONSTRAINT [DF_tblBankReconciliationInfo_Reconciled]  DEFAULT ((0)),
	[BankUploadId] [int] NOT NULL,
	[ProcessedDate] [datetime] NOT NULL,
	[BankRegisterId] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_tblBankReconciliationInfo] PRIMARY KEY CLUSTERED 
(
	[BankRegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblBankReconciliationInfo]  WITH NOCHECK ADD  CONSTRAINT [FK_tblBankReconciliationInfo_tblBankUpload] FOREIGN KEY([BankUploadId])
REFERENCES [dbo].[tblBankUpload] ([BankUploadId])
GO
ALTER TABLE [dbo].[tblBankReconciliationInfo] CHECK CONSTRAINT [FK_tblBankReconciliationInfo_tblBankUpload]
GO

GRANT SELECT ON tblBankReconciliationInfo TO PUBLIC

GO
