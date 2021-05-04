IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblStipulationLetterLog')
	BEGIN
		Create Table tblStipulationLetterLog(
			logid int not null identity(1,1) primary key clustered,
			datesent datetime not null default getdate(),
			sentby int not null,
			settlementid int not null,
			docfile varchar(max) not null,
			sendmethod varchar(100) not null,
			sentto varchar(255) not null,
			noteid int null
		)
	END
GO
