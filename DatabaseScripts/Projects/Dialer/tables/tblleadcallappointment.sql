IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadCallAppointment')
	BEGIN
		Create Table tblLeadCallAppointment(
			AppointmentId int identity(1,1) Primary Key Clustered,
			LeadApplicantId int not null,
			PhoneNumber varchar(20) not null,
			AppointmentDate datetime not null,
			TimeZoneId int not null,
			Created datetime not null default getdate(),
			CreatedBy int not null,
			LastModified datetime not null default getdate(),
			LastModifiedBy int not null,
			AppointmentNote varchar(1000) null,
			AppointmentStatusId int not null  default 0,
			CallMadeId int null,
			CallIdKey varchar(20) null,
			CalledBy int null,
			CallDate datetime null,
			CallResultId int null
		)
	END
GO
