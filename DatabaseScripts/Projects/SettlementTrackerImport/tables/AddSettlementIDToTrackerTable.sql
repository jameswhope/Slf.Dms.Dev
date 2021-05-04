IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementTrackerImports')
	BEGIN
		IF col_length('tblSettlementTrackerImports', 'SettlementID') is null
			ALTER TABLE tblSettlementTrackerImports ADD [SettlementID] [Numeric]
	END 	
	BEGIN
		IF col_length('tblSettlementTrackerImports', 'LastModified') is null
			ALTER TABLE tblSettlementTrackerImports ADD [LastModified] [datetime]
	END 
	BEGIN
		IF col_length('tblSettlementTrackerImports', 'LastModifedBy') is null
			ALTER TABLE tblSettlementTrackerImports ADD [LastModifiedBy] [int]
	END  