IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	BEGIN
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeAmtBeingPaid')
			BEGIN
				EXEC sp_rename 'tblsettlements.SettlementAmtBeingPaid','SettlementFeeAmtBeingPaid'
			END
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeAmtStillOwed')
			BEGIN
				EXEC sp_rename 'tblsettlements.SettlementAmtStillOwed','SettlementFeeAmtStillOwed'
			END
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementAmtStillOwed')
			BEGIN
				EXEC sp_rename 'tblsettlements.SettlementAmtSillOwed','SettlementAmtStillOwed'
			END
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementFeeCredit')
			BEGIN
				ALTER TABLE tblsettlements ADD SettlementFeeCredit money NULL
			END					
		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='SettlementSessionGuid')
			BEGIN
				ALTER TABLE tblsettlements ALTER COLUMN SettlementSessionGuid varchar(50) NULL
			END	
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='MatterId')
			BEGIN
				ALTER TABLE tblsettlements Add MatterId int NULL
			END	
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.Columns WHERE table_name='tblsettlements' AND column_name='LocalCounselId')
			BEGIN
				ALTER TABLE tblsettlements Add LocalCounselId int NULL
			END		
		ALTER TABLE [dbo].[tblSettlements]  WITH CHECK ADD  CONSTRAINT [FK_tblSettlements_tblMatter] FOREIGN KEY([MatterId])
		REFERENCES [dbo].[tblMatter] ([MatterId])

		ALTER TABLE [dbo].[tblSettlements] CHECK CONSTRAINT [FK_tblSettlements_tblMatter]							
	END