set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <05 - 17 February 2010>
      Category    : [TimeMatter]
      Type        : {Update}
      Decription  : Returns Tasks added relation to Matter
*/
ALTER procedure [dbo].[stp_GetTasks]
	(
		@returntop varchar (50) = '100 percent',
		@shortdescription int = 30,
		@where varchar (8000) = '',
		@orderby varchar (8000) = ''
	)

as
--edited
--CASE WHEN tbltasktype.tasktypecategoryId= 9 THEN tbltask.description
--			 ELSE tbltasktype.name END as tasktypename,
set @where = @where + ' and IsNull(tblmatter.IsDeleted,0)=0 '
exec
(
	'select top ' + @returntop + '
		tblclienttask.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as clientname,
		tbltasktype.name as tasktypename,
		tblassignedtogroup.name as AssignedtoGroup,
		tbltasktypecategory.tasktypecategoryid,
		tbltasktypecategory.name as tasktypecategoryname,
		tbltaskresolution.name as taskresolutionname,
		tbltask.*,
		substring(tbltask.description, 0, ' + @shortdescription + ') + ''...'' as shortdescription,
		tblassignedto.firstname + '' '' + tblassignedto.lastname as assignedtoname,
		tblresolvedby.firstname + '' '' + tblresolvedby.lastname as resolvedbyname,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname 
	from
		tbltask left outer join
		tblclienttask on tbltask.taskid = tblclienttask.taskid left outer join
		tblclient on tblclienttask.clientid = tblclient.clientid left outer join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbltasktype on tbltask.tasktypeid = tbltasktype.tasktypeid left outer join
		tbltasktypecategory on tbltasktype.tasktypecategoryid = tbltasktypecategory.tasktypecategoryid left outer join
		tbltaskresolution on tbltask.taskresolutionid = tbltaskresolution.taskresolutionid left outer join
		tbluser as tblassignedto on tbltask.assignedto = tblassignedto.userid left outer join
		tblusergroup as tblassignedtogroup on tbltask.AssignedToGroupId = tblassignedtogroup.usergroupid left outer join
		tbluser as tblresolvedby on tbltask.resolvedby = tblresolvedby.userid left outer join
		tbluser as tblcreatedby on tbltask.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tbltask.lastmodifiedby = tbllastmodifiedby.userid
		left outer join tblmattertask on tblmattertask.taskid = tbltask.taskid
		left outer join tblmatter on tblmattertask.matterid=tblmatter.matterid

	' + @where + ' ' + @orderby
)









