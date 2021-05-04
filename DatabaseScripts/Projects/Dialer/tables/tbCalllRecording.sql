IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCallRecording')
	BEGIN
		CREATE TABLE tblCallRecording
		(
			RecId int not null identity(1,1) Primary Key,
			CallIdKey varchar(20) not null,
			Created datetime not null  default GetDate(),
			RecCallIdKey varchar(20),
			RecFile varchar(1000),
			Reference varchar(20),
			ReferenceId int,
			CreatedBy int not null,
			DocTypeId nvarchar(50)
		)
END
GO


 
