IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblVerificationCall')
	BEGIN
	CREATE TABLE tblVerificationCall(
		VerificationCallId int identity(1,1) not null Primary Key,
		ClientId int not null,
		StartDate datetime not null default GetDate(),
		EndDate datetime null,
		Completed bit not null default 0,
		ExecutedBy int not null,
		RecordedCallPath varchar(1000) null,
		DocumentPath varchar(1000) null,
		CallIdKey varchar(50) not null,
		RecCallIdKey varchar(50) null,
		LanguageId int not null default 1,
		LastStep varchar(50) null
	)
	END
GO
