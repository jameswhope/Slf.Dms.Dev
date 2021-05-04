IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerClientLogSummary')
	BEGIN
		Create Table tblDialerClientLogSummary(
			DialerClientLogId int not null identity(1,1) Primary Key,
			ClientId int not null,
			ReasonId int not null,
			Created datetime not null default getdate(),
			LastCallDate datetime not null,
			DayCallCount int not null default 1
		)
	END
GO

