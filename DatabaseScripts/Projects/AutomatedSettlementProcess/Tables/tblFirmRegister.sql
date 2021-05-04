IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblFirmRegister')
	BEGIN
		DROP  Table tblFirmRegister
	END
GO

CREATE TABLE [dbo].[tblFirmRegister](
	[FirmRegisterId] [int] IDENTITY(1,1) NOT NULL,
	[RegisterId] [int] NOT NULL,
	[FeeRegisterId] [int] NULL,
	[FirmId] [int] NOT NULL,
	[ProcessedDate] [datetime] NOT NULL,
	[RequestType] [varchar](20) NOT NULL,
	[Amount] [money] NOT NULL,
	[CheckNumber] [int] NOT NULL,
	[ReferenceNumber] [varchar](50) NULL,
	[Detail] [varchar](50) NULL,
	[Cleared] [bit] NOT NULL CONSTRAINT [DF_tblFirmRegister_Reconciled]  DEFAULT ((0)),
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
	[RecipientAccountNumber] [varchar](50) NOT NULL,
	[RecipientName] [varchar](250) NOT NULL,
	[DataType] [varchar](20) NOT NULL,
	[Void] [bit] NULL CONSTRAINT [DF_tblFirmRegister_Void]  DEFAULT ((0)),
	[ClearedDate] [datetime] NULL,
	[VoidedDate] [datetime] NULL,
 CONSTRAINT [PK_tblFirmRegister] PRIMARY KEY CLUSTERED 
(
	[FirmRegisterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblFirmRegister]  WITH CHECK ADD  CONSTRAINT [FK_tblFirmRegister_tblCompany] FOREIGN KEY([FirmId])
REFERENCES [dbo].[tblCompany] ([CompanyID])
GO
ALTER TABLE [dbo].[tblFirmRegister] CHECK CONSTRAINT [FK_tblFirmRegister_tblCompany]
GO
ALTER TABLE [dbo].[tblFirmRegister]  WITH CHECK ADD  CONSTRAINT [FK_tblFirmRegister_tblModifiedUser] FOREIGN KEY([LastModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblFirmRegister] CHECK CONSTRAINT [FK_tblFirmRegister_tblModifiedUser]
GO
ALTER TABLE [dbo].[tblFirmRegister]  WITH CHECK ADD  CONSTRAINT [FK_tblFirmRegister_tblRegister] FOREIGN KEY([RegisterId])
REFERENCES [dbo].[tblRegister] ([RegisterId])
GO
ALTER TABLE [dbo].[tblFirmRegister] CHECK CONSTRAINT [FK_tblFirmRegister_tblRegister]
GO
ALTER TABLE [dbo].[tblFirmRegister]  WITH CHECK ADD  CONSTRAINT [FK_tblFirmRegister_tblUser] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO
ALTER TABLE [dbo].[tblFirmRegister] CHECK CONSTRAINT [FK_tblFirmRegister_tblUser]
GO


GRANT SELECT ON tblFirmRegister TO PUBLIC

GO

