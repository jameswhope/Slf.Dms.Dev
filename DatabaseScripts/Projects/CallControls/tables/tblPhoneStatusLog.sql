IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPhoneStatusLog')
	BEGIN
		CREATE TABLE tblPhoneStatusLog
			(PhoneStatusLogId int identity(1,1) not null Primary Key,
			 StatusName varchar(100) not null,
			 Created datetime not null,
			 UserID int not null   			 
			)
	END
GO
