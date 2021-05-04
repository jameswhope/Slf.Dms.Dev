IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertImportClientJob')
	BEGIN
		DROP  Procedure  stp_InsertImportClientJob
	END

GO

CREATE Procedure stp_InsertImportClientJob
@SourceId int 
AS
BEGIN
Insert Into tblImportClientJob(SourceId) Values (@SourceId)

Select SCOPE_IDENTITY() 
END
