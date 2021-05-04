IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlements')
	BEGIN
		ALTER TABLE tblSettlements ADD [Active] [bit] NULL
	END 
	
