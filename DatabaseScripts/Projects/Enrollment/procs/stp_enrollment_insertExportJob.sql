IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_insertLeadExportJob')
	BEGIN
		DROP PROCEDURE stp_enrollment_insertLeadExportJob
	END
GO

CREATE PROCEDURE stp_enrollment_insertLeadExportJob
@UserId int
AS
BEGIN

	Insert into tblLeadExportJob(ExecutedBy) VALUES (@UserId)
	
	SELECT SCOPE_IDENTITY()
END
