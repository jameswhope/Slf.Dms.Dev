IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblImportClientJob')
	BEGIN
		CREATE TABLE tblImportClientJob
(
		ImportJobId int not null identity(1,1) Primary Key,
		SourceId int not null,
		Created datetime not null default Getdate()
)
	END
GO

