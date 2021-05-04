IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblProcessingReport')
	BEGIN
		 CREATE TABLE tblProcessingReport
		(	
			ReportId int identity(1,1) not null
		   ,ReportDate datetime not null default getdate()
		   ,SessionId varchar(50)
		   ,Notes varchar(max)
		   ,ReportType varchar(10)
		)
	END
ELSE
	BEGIN
		IF col_length('tblProcessingReport', 'ReportType') is null
			Alter table tblProcessingReport Add ReportType varchar(10) null
	END
GO

