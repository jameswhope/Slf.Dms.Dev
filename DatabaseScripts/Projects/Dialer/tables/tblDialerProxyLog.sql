IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerProxyLog')
	BEGIN
		Create Table tblDialerProxyLog(
			ProxyLogId int identity(1,1) Primary Key,
			CallId varchar(20) not null,
			EventType varchar(20) not null,
			EventSubType varchar(20) not null,
			Created datetime not null default getdate()
		)
	END
GO

 