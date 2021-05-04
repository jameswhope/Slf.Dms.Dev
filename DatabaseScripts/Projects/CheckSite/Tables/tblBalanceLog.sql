IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblBalanceLog')
	BEGIN
		CREATE Table tblBalanceLog(
			ClientId int not null Primary Key,
			LastCheck datetime,
			Balanced bit not null default 0
		)
	END
GO


