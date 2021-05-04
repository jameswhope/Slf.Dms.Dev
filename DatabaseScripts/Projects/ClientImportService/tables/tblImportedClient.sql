IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblImportedClient')
	BEGIN
		CREATE TABLE tblImportedClient
		(	
			ImportId int not null identity(1,1) Primary Key,
			ImportJobId int not null,
			SourceId int not null,
			ExternalClientId varchar(50) not null,
			Created datetime not null default GetDate()
		)
		CREATE UNIQUE INDEX idx_importedclient ON tblImportedClient(SourceId,ExternalClientId)
	END
GO

