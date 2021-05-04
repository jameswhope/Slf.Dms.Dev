
if object_id('tblCompanyStatePrimary') is null begin
	create table tblCompanyStatePrimary
	(
		StatePrimaryID int identity(1,1) not null
	,	CompanyID int not null 
	,	AttorneyID int not null
	,	State varchar(10) not null
	,	Created datetime default(getdate())
	,	CreatedBy int
	,	LastModified datetime null
	,	LastModifiedBy int
	,	foreign key (CompanyID) references tblCompany(CompanyID) on delete cascade
	,	foreign key (AttorneyID) references tblAttorney(AttorneyID) on delete no action 
	)
end