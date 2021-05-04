IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblState')
 BEGIN
	IF col_length('tblState', 'DefaultTimeZone') is null
		Alter table tblState Add DefaultTimeZone int null  
END