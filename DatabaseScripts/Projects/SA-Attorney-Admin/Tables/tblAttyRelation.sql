/****** Object:  Table [dbo].[tblAttyRelation]    Script Date: 11/19/2007 11:02:58 ******/

if object_id('tblAttyRelation') is null begin
	CREATE TABLE [dbo].[tblAttyRelation](
		[AttyPivotID] [int] IDENTITY(1,1) NOT NULL,
		[AttorneyID] [int] NOT NULL,
		[CompanyID] [int] NULL,
		[AttyRelation] [nvarchar](50) NULL,
	) ON [PRIMARY]
end

/*
	11/30/07	jhernandez		Adding foreign key contraints
*/
if not exists (select 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk , INFORMATION_SCHEMA.KEY_COLUMN_USAGE c where pk.TABLE_NAME = 'tblAttyRelation' and CONSTRAINT_TYPE = 'FOREIGN KEY' and c.TABLE_NAME = pk.TABLE_NAME and c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME and c.COLUMN_NAME = 'AttorneyID') begin
	-- removing orphan attorney ids
	delete from tblAttyRelation where AttorneyID not in (select AttorneyID from tblAttorney)
	-- adding foreign key constraint
	alter table tblAttyRelation add foreign key (AttorneyID) references tblAttorney(AttorneyID) on delete cascade
end

if not exists (select 1 from INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk , INFORMATION_SCHEMA.KEY_COLUMN_USAGE c where pk.TABLE_NAME = 'tblAttyRelation' and CONSTRAINT_TYPE = 'FOREIGN KEY' and c.TABLE_NAME = pk.TABLE_NAME and c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME and c.COLUMN_NAME = 'CompanyID') begin
	alter table tblAttyRelation add foreign key (CompanyID) references tblCompany(CompanyID) on delete cascade
end


/*
	03/10/08	jhernandez		If the attorney has an employed relation, this field will indicate which state
								is their employed state since they may have multiple state licenses
*/
if not exists (select 1 from syscolumns where id = object_id('tblAttyRelation') and name = 'EmployedState') begin
	alter table tblAttyRelation add EmployedState varchar(10) null
end
go


/*
	03/04/08	jhernandez		Bug 414
*/
if not exists (select 1 from syscolumns where id = object_id('tblAttyRelation') and name = 'Created') begin
	alter table tblAttyRelation add Created datetime default(getdate())
end
go

if not exists (select 1 from syscolumns where id = object_id('tblAttyRelation') and name = 'CreatedBy') begin
	alter table tblAttyRelation add CreatedBy int
end
go

if not exists (select 1 from syscolumns where id = object_id('tblAttyRelation') and name = 'LastModified') begin
	alter table tblAttyRelation add LastModified datetime default(getdate())
end
go

if not exists (select 1 from syscolumns where id = object_id('tblAttyRelation') and name = 'LastModifiedBy') begin
	alter table tblAttyRelation add LastModifiedBy int
end
go
-- end Bug 414
