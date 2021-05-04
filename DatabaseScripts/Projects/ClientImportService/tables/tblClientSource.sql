IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClientSource')
	BEGIN
		CREATE  Table tblClientSource(
			SourceId int not null PRIMARY KEY,
			SourceName varchar(255) not null)
			
		INSERT INTO tblClientSource(SourceId, SourceName) VALUES (1, 'Smart Debtor')
	END
GO

