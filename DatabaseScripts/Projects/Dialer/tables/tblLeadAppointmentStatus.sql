IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadAppointmentStatus')
	BEGIN
		Create  Table tblLeadAppointmentStatus(
			AppointmentStatusId int not null Primary Key Clustered,
			StatusName varchar(25) 
		)
		
	END
GO

 