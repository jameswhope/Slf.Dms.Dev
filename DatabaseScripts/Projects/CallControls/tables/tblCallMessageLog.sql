IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCallMessageLog')
	BEGIN
		CREATE TABLE tblCallMessageLog
			(CallMessageId int identity(1,1) not null Primary Key,
			 Message varchar(4000) null,
			 MessageDate datetime not null,
			 UserID int not null   			 
			)
	END
GO
