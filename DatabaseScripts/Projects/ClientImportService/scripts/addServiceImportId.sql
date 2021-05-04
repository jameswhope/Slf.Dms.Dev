 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClient')
	IF col_length('tblClient', 'ServiceImportId') is null
			Alter table tblClient Add ServiceImportId int null