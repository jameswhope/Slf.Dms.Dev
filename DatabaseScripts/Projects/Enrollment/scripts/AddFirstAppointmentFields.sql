IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadApplicant')
BEGIN
	IF col_length('tblLeadApplicant', 'FirstAppointmentDate') is null
			Alter table tblLeadApplicant Add FirstAppointmentDate datetime null  
	IF col_length('tblLeadApplicant', 'TimeZoneId') is null
		Alter table tblLeadApplicant Add TimeZoneId int null  
END
GO