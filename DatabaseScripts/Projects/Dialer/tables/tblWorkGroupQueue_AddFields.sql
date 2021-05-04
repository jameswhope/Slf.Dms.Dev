 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerWorkGroupQueue')
BEGIN
	IF col_length('tblDialerWorkGroupQueue', 'MaxAttemptsPerDay') is null
		Alter table tblDialerWorkGroupQueue Add MaxAttemptsPerDay int not null default 0  
END
GO