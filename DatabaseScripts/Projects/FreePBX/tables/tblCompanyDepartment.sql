IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCompanyDepartment')
	BEGIN
		CREATE  Table tblCompanyDepartment(
			CompanyId int not null,
			DepartmentId int not null,
			OutCallerID varchar(50) not null ,
			Created  datetime not null default GetDate(),
			CreatedBy int not null,
			primary key (CompanyId , DepartmentId),
			foreign key (DepartmentID) references tblDepartment(DepartmentID) on delete cascade,
			foreign key (CompanyId) references tblCompany(CompanyId) on delete cascade
		)
	END
GO