IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCallLog')
	BEGIN
		CREATE TABLE tblCallLog
			(CallLogId int identity(1,1) not null Primary Key,
			 CallIdKey varchar(50),
			 PhoneNumber varchar(50) null,
			 EventName varchar(50) not null,
			 EventDate datetime not null,
			 EventBy int not null  
			)
	END
GO
