 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblMAtter')
 BEGIN
	IF col_length('tblMatter', 'DialerStatusId') is null
		Alter table tblMatter Add DialerStatusId int not null default 0 
		
	IF col_length('tblMatter', 'LastViciStatusCode') is null
		Alter table tblMatter Add LastViciStatusCode varchar(20) null
		
	IF col_length('tblMatter', 'LastViciStatusDate') is null
		Alter table tblMatter Add LastViciStatusDate datetime null
		
	IF col_length('tblMatter', 'LastContacted') is null
		Alter table tblMatter Add LastContacted datetime null
		
	IF col_length('tblMatter', 'DialerCount') is null
		Alter table tblMatter Add DialerCount int not null default 0 	 	
		 
 END
 
 GO