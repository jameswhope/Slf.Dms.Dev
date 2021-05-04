
 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciList')
 BEGIN	
	Create Table tblViciList(
		ViciListId int not null Primary Key Clustered,
		ViciMainListId int not null,
	)
 END
 
 GO
 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblViciList')
 BEGIN
	Delete  from tblViciList
 	Insert  into tblViciList(ViciListId, ViciMainListId) Values (110,110)
 	Insert  into tblViciList(ViciListId, ViciMainListId) Values (113,110)
 	Insert  into tblViciList(ViciListId, ViciMainListId) Values (111,111)
 	Insert  into tblViciList(ViciListId, ViciMainListId) Values (112,111)
 END
 
 