IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadSettlementFee')
	BEGIN
CREATE TABLE [dbo].[tblLeadSettlementFee](
	[SettlementFeeID] [int] IDENTITY(1,1) NOT NULL,
	[SettlementFee] [int] NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Modified] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_tblLeadSettlementFee] PRIMARY KEY CLUSTERED 
(
	[SettlementFeeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
	END


