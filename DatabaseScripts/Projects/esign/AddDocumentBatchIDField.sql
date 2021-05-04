 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDocuments')
	Begin
		IF col_length('tblLeadDocuments', 'SigningBatchID') is null
				Alter table tblLeadDocuments Add SigningBatchID varchar(50) Null 
	End  
 	Begin
		IF col_length('tblLeadDocuments', 'SigningIPAddress') is null
				Alter table tblLeadDocuments Add SigningIPAddress varchar(50) Null 
	End  
