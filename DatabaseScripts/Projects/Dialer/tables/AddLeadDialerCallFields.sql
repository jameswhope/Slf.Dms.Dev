 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDialerCall')
 BEGIN
	IF col_length('tblLeadDialerCall', 'QueueId') is null
		Alter table tblLeadDialerCall Add QueueId int not null default 3 
END
GO