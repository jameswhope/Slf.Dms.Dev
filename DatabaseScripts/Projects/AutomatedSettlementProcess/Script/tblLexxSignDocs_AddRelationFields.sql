 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tbllexxsigndocs')
	Begin
		IF col_length('tbllexxsigndocs', 'RelationTypeID') is null
				Alter table tbllexxsigndocs Add RelationTypeID int Null 
	End  
	Begin
		IF col_length('tbllexxsigndocs', 'RelationID') is null
				Alter table tbllexxsigndocs Add RelationID int Null 
	End  