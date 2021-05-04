IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDialerAudioFile')
	BEGIN
		Create  Table tblDialerAudioFile(
			FileId int not null identity(1,1) Primary Key,
			FileType varchar(255) not null,
			FileName varchar(255) not null,
			CompanyId int not null,
			LanguageId int not null,
			ReasonId int not null
		)
		
	END
GO

