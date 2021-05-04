 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTask')
	Begin
		IF col_length('tblTask', 'MatterID') is null
				Alter table tblTask Add MatterID int Null 
	End  
	
