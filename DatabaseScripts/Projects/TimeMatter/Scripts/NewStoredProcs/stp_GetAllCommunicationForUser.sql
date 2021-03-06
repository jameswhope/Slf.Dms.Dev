set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <03 - 17 February 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Decription  : Get All communication for the user on the home page
*/
CREATE procedure [dbo].[stp_GetAllCommunicationForUser]
(
	@returntop varchar (50) = '100 percent',
	@userid int,
	@shortvalue int = 150,
	@type varchar(100) = 'type=''note'' OR type=''email'' OR type=''phonecall'''
)

as

--create our results table
create table #tblResults
([type] varchar(20),
[date] datetime,
clientid int,
[client] varchar(255),
message varchar(5000),
shortmessage varchar(5000),
[lastmodifiedby] varchar(255),
[createdby] varchar(255),
fieldid int,
userid int
)

exec
(
'insert into #tblResults
	select
		''note'' as type,
		t.lastmodified as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		t.[value] as message,
		substring(t.[value], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,		
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		t.noteid as fieldid,
		t.createdby
	from
		tblnote t inner join
		tblclient on t.clientid = tblclient.clientid inner join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tblnoterelation nr on t.noteid=nr.noteid left outer join 
		tblrelationtype rt on rt.relationtypeid = nr.relationtypeid left outer join 
		tblmatter mtr on nr.relationid=mtr.matterid left outer join
		tblclient ct on nr.relationid=ct.clientid
	where
		isnull(mtr.IsDeleted,0)=0 and t.lastmodifiedby = ' + @userid
)
	
exec
(

'insert into #tblResults
	select
		''email'' as type,
		t.CreatedDate as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		t.[MailSubject] as message,
		substring(t.[MailSubject], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,		
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		t.EMailLogID as fieldid,
		t.CreatedBy
	from
		tblEmailRelayLog t inner join
		tblclient on t.clientid = tblclient.clientid inner join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on t.createdby = tbllastmodifiedby.userid left outer join
		tblEmailRelayRelation rl on t.EMailLogID = rl.EMailLogID left outer join 
		tblrelationtype rt on rt.relationtypeid = rl.relationtypeid left outer join
		tblmatter mtr on rl.relationid=mtr.matterid left outer join
		tblclient ct on rl.relationid=ct.clientid
	where
		isnull(mtr.IsDeleted,0)=0 and t.CreatedBy = ' + @userid	
)


if @returntop='100 percent' begin
exec
(
'select
		* 
	from 
		#tblResults 
	where 
		'+ @type + '
	order by 
		date desc, 
		fieldid desc'
)
end else begin
exec
(
'select top ' + @returntop + ' 
	*
	from 
		#tblResults 
	where 
		'+ @type + '
	order by 
		date desc, 
		fieldid desc'
)
end

drop table #tblResults






