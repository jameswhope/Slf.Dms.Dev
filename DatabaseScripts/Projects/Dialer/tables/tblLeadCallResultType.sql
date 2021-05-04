IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDialerCallResultType')
	BEGIN
		Create Table tblLeadDialerCallResultType (
			LeadResultTypeId int not null Primary Key Clustered,
			ResultTypeId int not null,
			Expiration int not null default 60,
			LeadStatusId int not null,
			LeadReasonId int null,
			AppointmentStatusId int not null,
			IconPath varchar(255) null,
			TabOrder int not null default 0,
			
		)
	END
GO

 