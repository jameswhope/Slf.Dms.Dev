 IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCallClient')
	BEGIN
		CREATE TABLE tblCallClient
			(CallPageId int identity(1,1) not null Primary Key,
			 CallIdKey varchar(50) not null,
			 ClientId int not null
			)
	END
GO
