 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblPerson')
	Begin
		IF col_length('tblPerson', 'IsDeceased') is null
				Alter table tblPerson Add IsDeceased bit Null 
	End   