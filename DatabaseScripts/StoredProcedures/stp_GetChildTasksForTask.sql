/****** Object:  StoredProcedure [dbo].[stp_GetChildTasksForTask]    Script Date: 11/19/2007 15:27:05 ******/
DROP PROCEDURE [dbo].[stp_GetChildTasksForTask]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_GetChildTasksForTask]
	(
		@taskid int
	)

as


select
	tbltasktype.name as tasktypename,
	tbltasktypecategory.tasktypecategoryid,
	tbltasktypecategory.name as tasktypecategoryname,
	tbltaskresolution.name as taskresolutionname,
	tbltask.*,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tbltask left outer join
	tbltasktype on tbltask.tasktypeid = tbltasktype.tasktypeid left outer join
	tbltasktypecategory on tbltasktype.tasktypecategoryid = tbltasktypecategory.tasktypecategoryid left outer join
	tbltaskresolution on tbltask.taskresolutionid = tbltaskresolution.taskresolutionid left outer join
	tbluser as tblcreatedby on tbltask.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tbltask.lastmodifiedby = tbllastmodifiedby.userid
where
	tbltask.parenttaskid = @taskid
GO
