IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_workflow_resolveTask')
	BEGIN
		DROP  Procedure  stp_workflow_resolveTask
	END

GO

CREATE Procedure stp_workflow_resolveTask
	(
		@taskID int,
		@userid int,
		@taskresolutionID int
	)

AS
BEGIN
	declare @matterid int,@nextTaskTypeid int,@nextTaskid int

	select 
		@nextTaskTypeid = tasktypeid
		,@matterid = matterid
		,@nextTaskid=taskID 
	from 
		tbltask 
	where 
		parenttaskid = @taskid

	update tbltask
	set resolved = getdate(), resolvedby = @userid, taskresolutionID = @taskresolutionID,lastmodified = getdate(), lastmodifiedby = @userid
	where taskid = @taskID

	update tblmatter
	set mattersubstatusid = @nextTaskTypeid, currenttaskid = @nextTaskid
	where matterid = @matterid
	
	
END

GO


GRANT EXEC ON stp_workflow_resolveTask TO PUBLIC

GO


