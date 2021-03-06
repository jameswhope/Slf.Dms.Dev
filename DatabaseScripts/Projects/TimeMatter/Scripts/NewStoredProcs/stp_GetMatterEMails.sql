set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <01 - 27 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription  : Get Matter emails
*/
CREATE procedure [dbo].[stp_GetMatterEMails]
	(
		@returntop varchar (50) = '100 percent',
		@MatterId int,
		@orderby varchar(50)='[Emaildate] desc',  
		@shortvalue int = 150
	)

as
exec
(
	'select
		''email'' as type,
		t.createdDate as [Emaildate],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + ''</br>'' + ug.Name as [by],
		t.[MailSubject] as message,
		substring(t.[MailSubject], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,
		t.EMailLogID as fieldid
	from
		(
		select top ' + @returntop + '
			*
		from
			tblEmailRelayLog
		)
		as t inner join
		tblEmailRelayRelation logrelation on t.EMailLogID = logrelation.EMailLogID left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.CreatedBy = tbllastmodifiedby.userid inner join 
		tblusergroup as ug on ug.usergroupid = t.usergroupid
	
	Where logrelation.RelationTypeID=19 and logrelation.Relationid =  ' + @MatterId + '
	

 order by ' +  @orderby
)



