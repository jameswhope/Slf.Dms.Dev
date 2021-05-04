IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClient')
 BEGIN
	IF col_length('tblClient', 'DialerResumeAfter') is null
		Alter table tblClient Add DialerResumeAfter Datetime null  
END
GO