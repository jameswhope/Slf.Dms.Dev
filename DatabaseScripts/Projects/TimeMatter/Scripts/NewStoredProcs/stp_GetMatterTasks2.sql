set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <03 - 18 February 2009>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Returns the tasks for Matters        
					Display only editable Tasks
*/
CREATE procedure [dbo].[stp_GetMatterTasks2]
(
      @MatterId int,
	  @OrderBy varchar(100)=''
)
AS

--- Display only editable Tasks
BEGIN
declare @clientjoin varchar(1000)

set @clientjoin = ' Select T.TaskID, M.MatterID, T.Created as CreatedDate, T.Due as DueDate, T.TaskResolutionId,
Case T.TaskTypeID When 0 Then ''Ad Hoc''Else (Select [Name] from tbltasktype Where TaskTypeID=T.TaskTypeID) End as TaskType,
(Select FirstName+'' ''+ LastName from tbluser Where UserID=T.AssignedTo) as AssignedTo, T.Description,
(Select FirstName+'' ''+ LastName from tbluser Where UserID=T.CreatedBy) as CreatedBy, T.Resolved
FROM dbo.tblMatterTask M, dbo.tblTask T
Where M.TaskID=T.TaskID and M.MatterID='+ cast(@MatterId as varchar)+' order by '+@OrderBy

exec(@clientjoin)


END





