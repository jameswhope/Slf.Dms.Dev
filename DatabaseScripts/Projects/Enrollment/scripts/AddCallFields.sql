IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadCall')
	Begin
		IF col_length('tblLeadCall', 'LastModified') is null
				Alter table tblLeadCall Add LastModified datetime Not Null default GetDate()
		IF col_length('tblLeadCall', 'LastModifiedBy ') is null
				Alter table tblLeadCall Add LastModifiedBy int Not null default 0
	End  
