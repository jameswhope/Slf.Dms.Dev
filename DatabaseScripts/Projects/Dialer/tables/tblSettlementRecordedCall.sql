drop table tblSettlementRecordedCall
go
IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSettlementRecordedCall')
	BEGIN
		CREATE TABLE tblSettlementRecordedCall(
			SettlementRecId int identity(1,1) not null Primary Key,
			SettlementId int not null,
			StartDate datetime not null default GetDate(),
			EndDate datetime null,
			Completed bit not null default 0,
			ExecutedBy int not null,
			DocumentPath varchar(1000) null,
			RecId int null,
			CallIdKey varchar(50) null,
			LanguageId int not null default 1,
			LastStep varchar(50) null
		)
	END
GO
