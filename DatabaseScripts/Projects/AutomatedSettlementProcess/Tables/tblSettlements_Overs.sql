CREATE TABLE [dbo].[tblSettlements_Overs](
	[OverID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SettlementID] [numeric](18, 0) NULL,
	[Created] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[Approved] [datetime] NULL,
	[ApprovedBy] [int] NULL,
	[OverAmount] [money] NULL,
 CONSTRAINT [PK_tblSettlements_Overs] PRIMARY KEY CLUSTERED 
(
	[OverID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GRANT SELECT ON tblSettlements_Overs TO PUBLIC

GO

