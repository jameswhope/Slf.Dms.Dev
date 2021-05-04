 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	Begin
		IF col_length('tblSettlements', 'AdjustedSettlementFee') is null
				Alter table tblSettlements Add AdjustedSettlementFee money Null 
	End  
ALTER TABLE [dbo].[tblSettlements] ADD  CONSTRAINT [DF_tblSettlements_AdjustedSettlementFee]  DEFAULT ((0.00)) FOR [AdjustedSettlementFee]  