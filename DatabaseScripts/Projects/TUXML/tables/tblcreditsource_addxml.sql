IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblcreditsource')
 BEGIN
	IF col_length('tblcreditsource', 'XmlFile') is null
		Alter table tblcreditsource Add XmlFile varchar(1000)
		
	IF col_length('tblcreditsource', 'RequestStatus') is null
		Alter table tblcreditsource Add RequestStatus varchar(50)
	
	IF col_length('tblcreditsource', 'FileHitIndicator') is null
		Alter table tblcreditsource Add FileHitIndicator varchar(100)
		
	IF col_length('tblcreditsource', 'Flags') is null
		Alter table tblcreditsource Add Flags int
		
	IF col_length('tblcreditsource', 'Status') is null
		Alter table tblcreditsource Add Status varchar(50)
		
	IF col_length('tblcreditsource', 'StatusMessage') is null
		Alter table tblcreditsource Add StatusMessage varchar(max) null
		
	IF col_length('tblcreditsource', 'ReuseId') is null
		Alter table tblcreditsource Add ReuseId int null
		
 END