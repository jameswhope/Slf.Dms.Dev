drop table tblAstConferenceCall
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAstConferenceCall')
	BEGIN
		CREATE  Table tblAstConferenceCall(
			ConferenceCallId int not null identity(1,1) primary key clustered,
			Created datetime not null default GetDate(),
			CallId int not null,
			UserId int not null,
			BridgeChannel varchar(50) null,
			PhoneNumber varchar(20),
			PhoneSystem varchar(50) null,
			CallerId varchar(20) null
		)
	END
GO

