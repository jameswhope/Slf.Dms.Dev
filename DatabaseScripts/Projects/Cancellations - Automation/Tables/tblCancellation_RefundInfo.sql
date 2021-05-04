IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCancellation_RefundInfo')
	BEGIN
		DROP  Table tblCancellation_RefundInfo
	END
GO

CREATE TABLE [dbo].[tblCancellation_RefundInfo](
	[RefundId] [int] IDENTITY(1,1) NOT NULL,
	[MatterId] [int] NOT NULL,
	[RegisterId] [int] NOT NULL,
	[EntryTypeId] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[LastModified] [datetime] NOT NULL,
	[LastModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_tblCancellation_RefundInfo_1] PRIMARY KEY CLUSTERED 
(
	[RefundId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblCancellation_RefundInfo]  WITH CHECK ADD  CONSTRAINT [FK_tblCancellation_RefundInfo_tblRegister] FOREIGN KEY([RegisterId])
REFERENCES [dbo].[tblRegister] ([RegisterId])
GO
ALTER TABLE [dbo].[tblCancellation_RefundInfo] CHECK CONSTRAINT [FK_tblCancellation_RefundInfo_tblRegister]
GO

