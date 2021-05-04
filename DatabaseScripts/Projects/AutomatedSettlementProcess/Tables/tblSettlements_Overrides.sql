IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements_Overrides')
	BEGIN
		DROP  Table tblSettlements_Overrides
	END
GO

CREATE TABLE [dbo].[tblSettlements_Overrides](
	[OverrideID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SettlementID] [numeric](18, 0) NULL,
	[OverrideAccountID] [numeric](18, 0) NULL,
	[FieldName] [varchar](500) NULL,
	[RealValue] [varchar](500) NULL,
	[EnteredValue] [varchar](500) NULL,
	[CreatedBy] [int] NOT NULL,
	[Created] [datetime] NOT NULL,
 CONSTRAINT [PK_tblSettlements_Overrides] PRIMARY KEY CLUSTERED 
(
	[OverrideID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]



GRANT SELECT ON tblSettlements_Overrides TO PUBLIC

GO

