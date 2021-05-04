IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadExportJob')
	BEGIN
		CREATE TABLE tblLeadExportJob
		(ExportJobId int not null identity(1,1) Primary Key,
		 ExportDate datetime not null default GetDate(),
		 ExecutedBy int not null,
		 Status bit not null default  0,
		 Notes varchar(max))
	END
GO

