
-- AUDIT TABLES, populated by Insert, Update, and Delete triggers

/* PHASE II
if object_id('dms_warehouse.dbo.AUDIT_tblCommScen') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblCommScen
	from tblCommScen
	where 1=1
end

alter table dms_warehouse.dbo.AUDIT_tblCommScen add DbName varchar(50)
alter table dms_warehouse.dbo.AUDIT_tblCommScen add RowAdded datetime default(getdate())
alter table dms_warehouse.dbo.AUDIT_tblCommScen add RowAddedBy varchar(100)
alter table dms_warehouse.dbo.AUDIT_tblCommScen add Deleted bit default(0)

update dms_warehouse.dbo.AUDIT_tblCommScen set DbName = db_name(), RowAdded = getdate(), RowAddedBy = SUSER_SNAME(), Deleted = 0 where RowAdded is null

PHASE II
- tblClient
- tblCommStruct
- tblCommFee

*/

if object_id('dms_warehouse.dbo.AUDIT_tblCommRec') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblCommRec
	from tblCommRec
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblCommRec add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblCommRec add RowAdded datetime default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblCommRec add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblCommRec add Deleted bit default(0)

	update dms_warehouse.dbo.AUDIT_tblCommRec set DbName = db_name(), RowAdded = getdate(), RowAddedBy = SUSER_SNAME(), Deleted = 0 where RowAdded is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblCompany') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblCompany
	from tblCompany
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblCompany add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblCompany add RowAdded datetime not null default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblCompany add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblCompany add Deleted bit not null default(0)

	update dms_warehouse.dbo.AUDIT_tblCompany set DbName = db_name(), RowAddedBy = SUSER_SNAME() where RowAddedBy is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblAttorney') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblAttorney
	from tblAttorney
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblAttorney add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblAttorney add RowAdded datetime not null default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblAttorney add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblAttorney add Deleted bit not null default(0)

	update dms_warehouse.dbo.AUDIT_tblAttorney set DbName = db_name(), RowAddedBy = SUSER_SNAME() where RowAddedBy is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblAttyRelation') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblAttyRelation
	from tblAttyRelation
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblAttyRelation add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblAttyRelation add RowAdded datetime not null default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblAttyRelation add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblAttyRelation add Deleted bit not null default(0)

	update dms_warehouse.dbo.AUDIT_tblAttyRelation set DbName = db_name(), RowAddedBy = SUSER_SNAME() where RowAddedBy is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblAgency') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblAgency
	from tblAgency
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblAgency add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblAgency add RowAdded datetime not null default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblAgency add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblAgency add Deleted bit not null default(0)

	update dms_warehouse.dbo.AUDIT_tblAgency set DbName = db_name(), RowAddedBy = SUSER_SNAME() where RowAddedBy is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblChildAgency') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblChildAgency
	from tblChildAgency
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblChildAgency add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblChildAgency add RowAdded datetime not null default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblChildAgency add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblChildAgency add Deleted bit not null default(0)

	update dms_warehouse.dbo.AUDIT_tblChildAgency set DbName = db_name(), RowAddedBy = SUSER_SNAME() where RowAddedBy is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary
	from tblCompanyStatePrimary
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary add RowAdded datetime default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary add Deleted bit default(0)

	update dms_warehouse.dbo.AUDIT_tblCompanyStatePrimary set DbName = db_name(), RowAdded = getdate(), RowAddedBy = SUSER_SNAME(), Deleted = 0 where RowAdded is null
end


if object_id('dms_warehouse.dbo.AUDIT_tblNACHARoot') is null begin
	select *
	into dms_warehouse.dbo.AUDIT_tblNACHARoot
	from tblNACHARoot
	where 1=1

	alter table dms_warehouse.dbo.AUDIT_tblNACHARoot add DbName varchar(50)
	alter table dms_warehouse.dbo.AUDIT_tblNACHARoot add RowAdded datetime default(getdate())
	alter table dms_warehouse.dbo.AUDIT_tblNACHARoot add RowAddedBy varchar(100)
	alter table dms_warehouse.dbo.AUDIT_tblNACHARoot add Deleted bit default(0)

	update dms_warehouse.dbo.AUDIT_tblNACHARoot set DbName = db_name(), RowAdded = getdate(), RowAddedBy = SUSER_SNAME(), Deleted = 0 where RowAdded is null
end

