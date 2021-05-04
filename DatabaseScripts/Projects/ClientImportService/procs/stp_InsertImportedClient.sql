IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_InsertImportedClient')
	BEGIN
		DROP  Procedure  stp_InsertImportedClient
	END

GO

CREATE Procedure stp_InsertImportedClient
@JobId int,
@SourceId int,
@ExternalClientId varchar(50)
AS
BEGIN
Insert Into tblImportedClient(ImportJobId, SourceId, ExternalClientId)
Values (@JobId, @SourceId, @ExternalClientId)

Select SCOPE_IDENTITY() 
END

GO


