IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblastcalllog')
 BEGIN
	IF col_length('tblAstcalllog', 'ViciStatusCode') is null
		Alter table tblAstcalllog Add ViciStatusCode varchar(10) null 
 END