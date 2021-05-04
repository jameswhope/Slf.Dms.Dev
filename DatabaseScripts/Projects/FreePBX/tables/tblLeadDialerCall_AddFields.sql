IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDialerCall')
 BEGIN
	IF col_length('tblLeadDialerCall', 'CallId') is null
		Alter table tblLeadDialerCall Add CallId int
		
	IF col_length('tblLeadDialerCall', 'AutoDial') is null
		Alter table tblLeadDialerCall Add AutoDial bit not null default 1
				 
 END