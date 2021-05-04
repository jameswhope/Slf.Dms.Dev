 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblMatter')
	Begin
		IF col_length('tblMatter', 'CurrentTaskID') is null
				Alter table tblMatter Add CurrentTaskID int Null 
	End  	 