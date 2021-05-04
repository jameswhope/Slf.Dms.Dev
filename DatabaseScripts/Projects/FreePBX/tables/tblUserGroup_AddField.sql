IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUserGroup')
 BEGIN
	IF col_length('tblUserGroup', 'DepartmentId') is null
		Alter table tblUserGroup Add DepartmentId int null
				 
 END