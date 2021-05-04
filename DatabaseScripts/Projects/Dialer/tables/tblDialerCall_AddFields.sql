IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerCall')
 BEGIN
	IF col_length('tblDialerCall', 'OutboundCallKey') is null
		Alter table tblDialerCall Add OutboundCallKey varchar(20) null  
END
GO
