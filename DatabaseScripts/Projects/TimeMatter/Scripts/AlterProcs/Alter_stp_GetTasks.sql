 /****** Object:  StoredProcedure [dbo].[stp_GetTasks]    Script Date: 11/19/2007 15:27:17 ******/
alter procedure [stp_GetTasks]
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
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname,
		IsNull(tblmatter.creditorinstanceid,0) as creditorinstanceid,
		tbllanguage.Name as Language,
		tblclient.AccountNumber as ClientAccountNumber,
		CASE WHEN tblmatter.CreditorInstanceId is null then ''None''
		 WHEN tblmatter.CreditorInstanceid=0 then ''TBD''
		 ELSE ''***''+ RIGHT(ci.AccountNumber,4)  END as CIAccountNumber ,
		CASE WHEN tbltask.Resolved is null then case when tbltask.taskresolutionid=1 then 1 else 2 end
		else CASE WHEN  Due<getdate() then 3 else 4 end end as seq,
		s.abbreviation[ClientState]
	from
		tbltask with(nolock) left outer join
		tblclienttask  with(nolock) on tbltask.taskid = tblclienttask.taskid left outer join
		tblclient  with(nolock) on tblclienttask.clientid = tblclient.clientid left outer join
		tblperson  with(nolock) on tblclient.primarypersonid = tblperson.personid left outer join
		tbllanguage  with(nolock) on tblperson.languageId = tbllanguage.LanguageId left outer join
		tbltasktype  with(nolock) on tbltask.tasktypeid = tbltasktype.tasktypeid left outer join
		tbltasktypecategory  with(nolock) on tbltasktype.tasktypecategoryid = tbltasktypecategory.tasktypecategoryid left outer join
		tbltaskresolution  with(nolock) on tbltask.taskresolutionid = tbltaskresolution.taskresolutionid left outer join
		tbluser as tblassignedto  with(nolock) on tbltask.assignedto = tblassignedto.userid left outer join
		tblusergroup as tblassignedtogroup  with(nolock) on tbltask.AssignedToGroupId = tblassignedtogroup.usergroupid left outer join
		tbluser as tblresolvedby  with(nolock) on tbltask.resolvedby = tblresolvedby.userid left outer join
		tbluser as tblcreatedby  with(nolock) on tbltask.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby  with(nolock) on tbltask.lastmodifiedby = tbllastmodifiedby.userid
		left outer join tblmattertask  with(nolock) on tblmattertask.taskid = tbltask.taskid
		left outer join tblmatter  with(nolock) on tblmattertask.matterid=tblmatter.matterid
		left outer join tblCreditorInstance ci  with(nolock) on ci.creditorinstanceid=tblmatter.creditorinstanceid
		inner join tblstate s on s.stateid = tblperson.stateid

	' + @where + ' ' + @orderby
)

GO
