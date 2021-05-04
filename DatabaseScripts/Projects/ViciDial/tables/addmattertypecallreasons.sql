 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblmattertype')
 BEGIN
	IF col_length('tblmattertype', 'DialerCallReasonTypeId') is null
		Alter table tblmattertype Add DialerCallReasonTypeId int null 
		
	IF col_length('tblmattertype', 'AstCallReasonId') is null
		Alter table tblmattertype Add AstCallReasonId int not null default 0
 END
 
 Go
 
 Update tblmattertype set DialerCallReasonTypeId = 1, AstCallReasonId = 2 Where MatterTypeId = 3
 Update tblmattertype set DialerCallReasonTypeId = 3, AstCallReasonId = 3 Where MatterTypeId = 5
  
 GO