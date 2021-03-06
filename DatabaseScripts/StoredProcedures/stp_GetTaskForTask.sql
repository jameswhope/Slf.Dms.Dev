/****** Object:  StoredProcedure [dbo].[stp_GetTaskForTask]    Script Date: 11/19/2007 15:27:17 ******/
DROP PROCEDURE [dbo].[stp_GetTaskForTask]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetTaskForTask]
	(
		@taskid int
	)

as


select
	tblclienttask.clientid,
	tblperson.firstname + ' ' + tblperson.lastname as clientname,
	tbltasktype.name as tasktypename,
	tbltasktypecategory.tasktypecategoryid,
	tbltasktypecategory.name as tasktypecategoryname,
	tbltaskresolution.name as taskresolutionname,
	tbltask.*,
	tblassignedto.firstname + ' ' + tblassignedto.lastname as assignedtoname,
	tblresolvedby.firstname + ' ' + tblresolvedby.lastname as resolvedbyname,
	tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,
	tbllastmodifiedby.firstname + ' ' + tbllastmodifiedby.lastname as lastmodifiedbyname
from
	tbltask left outer join
	tblclienttask on tbltask.taskid = tblclienttask.taskid left outer join
	tblclient on tblclienttask.clientid = tblclient.clientid left outer join
	tblperson on tblclient.primarypersonid = tblperson.personid left outer join
	tbltasktype on tbltask.tasktypeid = tbltasktype.tasktypeid left outer join
	tbltasktypecategory on tbltasktype.tasktypecategoryid = tbltasktypecategory.tasktypecategoryid left outer join
	tbltaskresolution on tbltask.taskresolutionid = tbltaskresolution.taskresolutionid left outer join
	tbluser as tblassignedto on tbltask.assignedto = tblassignedto.userid left outer join
	tbluser as tblresolvedby on tbltask.resolvedby = tblresolvedby.userid left outer join
	tbluser as tblcreatedby on tbltask.createdby = tblcreatedby.userid left outer join
	tbluser as tbllastmodifiedby on tbltask.lastmodifiedby = tbllastmodifiedby.userid
where
	tbltask.taskid = @taskid
GO
