 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPhone')
 BEGIN
	IF col_length('tblPhone', 'ExcludeFromDialer') is null
		Alter table tblPhone Add ExcludeFromDialer bit not null default 0  
END
GO