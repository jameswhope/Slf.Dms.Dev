IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciMatterCallSummary')
	BEGIN
		Create Table tblViciMatterCallSummary(
			MatterCallLogId int not null identity(1,1) Primary Key,
			MatterId int not null,
			ReasonId int not null,
			Created datetime not null default getdate(),
			CallDate datetime not null,
			LastCallDate datetime not null,
			DayCallCount int not null default 1
		)
	END
GO