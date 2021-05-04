IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadExportDetail')
	BEGIN
		CREATE TABLE tblLeadExportDetail
		(
		   LeadExportId int not null identity(1,1) Primary Key,
		   ExportJobId int not null,		   
		   LeadApplicantId int not null,
		   ExportStatus int not null default 0,
		   Note varchar(max)
		)
	END
GO

