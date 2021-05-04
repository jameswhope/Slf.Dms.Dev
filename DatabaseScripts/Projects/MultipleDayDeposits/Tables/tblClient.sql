
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblclient')
	IF col_length('tblclient', 'MultiDeposit') is null
			Alter table tblclient Add MultiDeposit bit not null default 0
GO

