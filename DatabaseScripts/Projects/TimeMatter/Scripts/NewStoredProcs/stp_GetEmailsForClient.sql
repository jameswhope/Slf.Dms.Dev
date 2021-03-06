set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <03 - 17 February 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription  : Get All emails for the client
*/
CREATE procedure [dbo].[stp_GetEmailsForClient]
(
		@ClientID int,
		@orderby varchar(50)='[date] desc',  
		@shortvalue int = 150
)

as
exec
(
	'select
		''email'' as type,
		t.createddate as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + ''</br>'' + ug.Name as [by],
		t.[MailSubject] as message,
		substring(t.[MailSubject], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,
		t.EMailLogID as fieldid
	from
		tblEmailRelayLog as t inner join
		tblclient on t.clientid = tblclient.clientid inner join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.createdby = tbllastmodifiedby.userid inner join 
		tblusergroup as ug on ug.usergroupid = t.usergroupid left outer join
		tblEmailRelayRelation rl on t.EMailLogID = rl.EMailLogID left outer join 
		tblrelationtype rt on rt.relationtypeid = rl.relationtypeid left outer join
		tblmatter mtr on rl.relationid=mtr.matterid left outer join
		tblclient ct on rl.relationid=ct.clientid

	Where isnull(mtr.IsDeleted,0)=0 and t.clientid = ' + @clientid + '
	
	order by ' +  @orderby
)





