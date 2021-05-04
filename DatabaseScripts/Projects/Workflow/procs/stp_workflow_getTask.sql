IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_workflow_getTask')
	BEGIN
		DROP  Procedure  stp_workflow_getTask
	END

GO

CREATE Procedure stp_workflow_getTask
	(
		@matterID int,
		@TaskTypeID int
	)

AS
BEGIN
	select * from tbltask where matterid = @matterID and tasktypeid = @TaskTypeID
END

GO

GRANT EXEC ON stp_workflow_getTask TO PUBLIC
GO


