 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDialerCall')
 BEGIN
	IF col_length('tblLeadDialerCall', 'ResultId') is null
		Alter table tblLeadDialerCall Add ResultId int null  
END
GO