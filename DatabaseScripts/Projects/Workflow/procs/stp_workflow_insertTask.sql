IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_workflow_insertTask')
	BEGIN
		DROP  Procedure  stp_workflow_insertTask
	END

GO

CREATE Procedure stp_workflow_insertTask
	(
		@TaskTypeId int,
		@ParentTaskID int = null,
		@Description varchar(500),
		@Due datetime,
		@userID int,
		@matterid int
	)
AS
BEGIN
	declare @currTaskID int
	
	INSERT INTO tblTask(TaskTypeId, ParentTaskID,[Description], Due, TaskResolutionId, Created,CreatedBy, LastModified, LastModifiedBy, AssignedTo, MatterID)
	VALUES(@TaskTypeId, @ParentTaskID,@Description, @Due, NULL, getdate(),@userID, getdate(), @userID, 0, @matterid);
	select @currTaskID  = IDENT_CURRENT ('tblTask')
	update tblmatter set currenttaskid = @currTaskID where matterid = @matterid
	update tblmattertask set taskid=@currTaskID where matterid = @matterid

	select @currTaskID 
END

GO


GRANT EXEC ON stp_workflow_insertTask TO PUBLIC

GO


