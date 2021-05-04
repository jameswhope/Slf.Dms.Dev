IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_AssignLastTaskToMatter')
	BEGIN
		DROP  Procedure  stp_AssignLastTaskToMatter
	END

GO

CREATE Procedure stp_AssignLastTaskToMatter
@MatterId int
AS
Begin
	declare @taskid int
	Select top 1 @TaskId = taskid from tblmattertask where matterid = @matterid order by mattertaskid desc

	if @taskid is not null
	Begin
		Update tblmatter Set CurrentTaskId = @TaskId Where MatterId = @matterid
		Update tblTask Set MatterId = @matterid where taskid = @taskid
	End 
End

GO


