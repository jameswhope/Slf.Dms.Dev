  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDocuments')
	Begin
		IF col_length('tblLeadDocuments', 'SigningBrowserName') is null
				Alter table tblLeadDocuments Add SigningBrowserName varchar(50) Null 
	End  
 	Begin
		IF col_length('tblLeadDocuments', 'SigningBrowserVersion') is null
				Alter table tblLeadDocuments Add SigningBrowserVersion varchar(50) Null 
	End  
	Begin
		IF col_length('tblLeadDocuments', 'SigningBrowserJSEnabled') is null
				Alter table tblLeadDocuments Add SigningBrowserJSEnabled bit Null 
	End  