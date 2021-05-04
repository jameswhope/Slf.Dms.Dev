IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDialerExt')
	BEGIN
		Create  Table tblLeadDialerExt(
			WorkgroupQueueId int not null Primary Key,
			GetLeadSP varchar(255) not null,
			GetLeadAppointmentSP varchar(255) null
		)
		
	END
GO

