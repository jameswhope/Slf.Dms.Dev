CREATE TABLE [dbo].[tblSettlements_DeliveryAddresses](
	[DeliveryID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SettlementID] [numeric](18, 0) NULL,
	[AttentionTo] [varchar](200) NULL,
	[Address] [varchar](500) NULL,
	[City] [varchar](200) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](20) NULL,
	[EmailAddress] [varchar](200) NULL,
	[ContactNumber] [varchar](200) NULL,
	[ContactName] [varchar](200) NULL,
	[PayableTo] [varchar](200) NULL,
 CONSTRAINT [PK_tblSettlements_DeliveryAddresses] PRIMARY KEY CLUSTERED 
(
	[DeliveryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



GRANT SELECT ON tblSettlements_DeliveryAddresses TO PUBLIC

GO

