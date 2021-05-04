IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgency')
	IF col_length('tblAgency', 'IsCommRec') is null
			Alter table tblAgency Add IsCommRec int not null default 0
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgency')
	IF col_length('tblAgency', 'CommRecGroupId') is null
			Alter table tblAgency Add CommRecGroupId int  null 
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgency')
	IF col_length('tblAgency', 'ParentAgencyId') is null
			Alter table tblAgency Add ParentAgencyId int  null 
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCommRec')
	IF col_length('tblCommRec', 'CommRecGroupId') is null
			Alter table tblCommRec Add CommRecGroupId int null
GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUser')
	IF col_length('tblUser', 'CommRecGroupId') is null
			Alter table tblUser Add CommRecGroupId int null
GO
