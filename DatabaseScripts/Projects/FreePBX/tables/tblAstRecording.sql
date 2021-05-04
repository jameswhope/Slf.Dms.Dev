IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAstRecording')
	BEGIN
		CREATE  Table tblAstRecording(
			RecId int not null identity(1,1) Primary Key Clustered,
			CallId int not null,
			Created datetime not null default GetDate(),
			RecPath varchar(1000),
			foreign key (CallId) references tblAstCallLog(CallId) on delete no action
		)
	END
GO

