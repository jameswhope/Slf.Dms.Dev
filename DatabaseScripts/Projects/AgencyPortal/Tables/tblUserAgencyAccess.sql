IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblUserAgencyAccess')
	BEGIN
		CREATE TABLE tblUserAgencyAccess
		(
			UserId int not null,  
			AgencyId int not null,
			constraint pk_UserAgencyAccess primary key clustered ( UserId, AgencyId ),
			foreign key (AgencyId) references tblAgency(AgencyId) on delete cascade
		)
	END
GO

