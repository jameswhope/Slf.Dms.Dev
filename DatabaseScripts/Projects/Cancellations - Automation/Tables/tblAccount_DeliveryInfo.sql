IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAccount_DeliveryInfo')
	BEGIN
		DROP  Table tblAccount_DeliveryInfo
	END
GO

CREATE TABLE tblAccount_DeliveryInfo(
	[MatterId] [int] NOT NULL,
	[DeliveryAddress] [varchar](250) NULL,
	[DeliveryCity] [varchar](250) NULL,
	[DeliveryState] [varchar](10) NULL,
	[DeliveryZip] [varchar](10) NULL,
	[DeliveryPhone] [varchar](20) NULL,
	[DeliveryFax] [varchar](20) NULL,
	[DeliveryEmail] [varchar](250) NULL,
	[PayableTo] [varchar](250) NULL,
	[AttentionTo] [varchar](100) NULL,
	[ContactName] [varchar](100) NULL,
	[DeliveryFee] [money] NULL,
	[DeliveryMethod] [varchar](5) NULL,
 CONSTRAINT [PK_tblAccount_DeliveryInfo] PRIMARY KEY CLUSTERED 
(
	[MatterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[tblAccount_DeliveryInfo]  WITH CHECK ADD  CONSTRAINT [FK_tblAccount_DeliveryInfo_tblMatter] FOREIGN KEY([MatterId])
REFERENCES [dbo].[tblMatter] ([MatterId])
GO
ALTER TABLE [dbo].[tblAccount_DeliveryInfo] CHECK CONSTRAINT [FK_tblAccount_DeliveryInfo_tblMatter]
GO


GRANT SELECT ON tblAccount_DeliveryInfo TO PUBLIC

GO

