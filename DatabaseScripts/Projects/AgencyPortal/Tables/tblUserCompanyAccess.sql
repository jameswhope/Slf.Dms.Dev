IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUserCompanyAccess')
	BEGIN
		CREATE TABLE tblUserCompanyAccess
		(
			UserId int not null,  
			CompanyId int not null,
			constraint pk_UserCompanyAccess primary key clustered ( UserId, CompanyId ),
			foreign key (CompanyId) references tblCompany(CompanyId) on delete cascade
		)
	END
GO 