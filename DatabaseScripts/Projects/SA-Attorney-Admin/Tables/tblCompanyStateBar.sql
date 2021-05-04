
if object_id('tblCompanyStateBar') is null begin
	create table tblCompanyStateBar
	(
		StateBarID int identity(1,1) not null
		primary key (StateBarID)
	,	CompanyID int not null 
		foreign key (CompanyID) references tblCompany(CompanyID) on delete cascade
	,	State char(2) not null
	,	StateBarNum varchar(30) not null
	,	Created datetime default(getdate())
	)
end 