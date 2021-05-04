IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblACWarning')
	BEGIN
		CREATE Table tblACHWarning(
			WarningId int not null identity(1,1) Primary Key,
			ItemId int not null,
			ItemType varchar(50) not null,
			MultiDeposit bit not null,
			Scheduled datetime not null)
		
	END
GO
