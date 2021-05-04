 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerCall')
 BEGIN
	IF col_length('tblDialerCall', 'PrimaryCallMadeId') is null
		Alter table tblDialerCall Add PrimaryCallMadeId int null  
END
GO