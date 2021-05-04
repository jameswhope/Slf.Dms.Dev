 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tbldialercallreasontype')
 BEGIN
	IF col_length('tbldialercallreasontype', 'CallStartTime') is null
		Alter table tbldialercallreasontype Add CallStartTime datetime not null default '1900-01-01 07:00:00.000'
	IF col_length('tbldialercallreasontype', 'CallEndTime') is null
		Alter table tbldialercallreasontype Add CallEndTime datetime not null default '1900-01-01 16:55:00.000'
	IF col_length('tbldialercallreasontype', 'Repeat') is null
		Alter table tbldialercallreasontype Add Repeat int not null default 1
	
END
GO 