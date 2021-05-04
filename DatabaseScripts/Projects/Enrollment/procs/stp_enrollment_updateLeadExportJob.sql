IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_updateLeadExportJob')
	BEGIN
		DROP  Procedure  stp_enrollment_updateLeadExportJob
	END

GO

CREATE Procedure stp_enrollment_updateLeadExportJob
@ExportJobId int,		   
@Status int = null,
@Notes varchar(max) = null
AS
BEGIN
	Update tblLeadExportJob Set
	Status = isnull(@Status, Status),
	Notes = isnull(@Notes, Notes) 
	Where ExportJobId = @ExportJobId
END

GO
