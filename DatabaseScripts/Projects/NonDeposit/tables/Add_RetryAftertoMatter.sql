 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblMatter')
	IF col_length('tblMatter', 'DialerRetryAfter') is null
		alter table tblMatter add DialerRetryAfter datetime null 
Go
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblMatter')
	IF col_length('tblMatter', 'DialerLock') is null
		alter table tblMatter add DialerLock bit not null default 0
Go
