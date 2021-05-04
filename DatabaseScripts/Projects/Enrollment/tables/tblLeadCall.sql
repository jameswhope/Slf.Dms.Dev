  IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadCall')
	BEGIN
		CREATE TABLE  tblLeadCall(
			LeadCallID int IDENTITY(1,1) not null Primary Key,
			LeadApplicantId int null,
			CallIdKey varchar(50) not null,
			Dnis varchar(50) not null,
			Ani varchar(50) not null,
			Created datetime not null,
			CreatedBy int not null			 
		)
	END
	
	go