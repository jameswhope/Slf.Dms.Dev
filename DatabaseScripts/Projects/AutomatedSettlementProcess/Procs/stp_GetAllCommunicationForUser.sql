IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAllCommunicationForUser')
	BEGIN
		DROP  Procedure  stp_GetAllCommunicationForUser
	END

GO

CREATE Procedure [dbo].[stp_GetAllCommunicationForUser]
(
	@returntop varchar (50) = '100 percent',
	@userid int,
	@shortvalue int = 150,
	@type varchar(100) = 'type=''note'' OR type=''email'' OR type=''phonecall'''
)

as

--create our results table
create table #tblResults
(
fieldid int,
[type] varchar(20),
[date] datetime,
clientid int,
[client] varchar(255),
message varchar(5000),
shortmessage varchar(5000),
[lastmodifiedby] varchar(255),
[createdby] varchar(255),
userid int
)

exec
(
'insert into #tblResults
	select
		distinct t.noteid as fieldid,
		''note'' as type,
		t.lastmodified as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		t.[value] as message,
		substring(t.[value], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,		
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,		
		t.createdby
	from
		tblnote t with(nolock) inner join
		tblclient with(nolock) on t.clientid = tblclient.clientid inner join
		tblperson with(nolock) on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby with(nolock) on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby with(nolock) on t.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tblnoterelation nr with(nolock) on t.noteid=nr.noteid left outer join 
		tblrelationtype rt with(nolock) on rt.relationtypeid = nr.relationtypeid left outer join 
		tblmatter mtr with(nolock) on nr.relationid=mtr.matterid left outer join
		tblclient ct  with(nolock) on nr.relationid=ct.clientid
	where
		isnull(mtr.IsDeleted,0)=0 and t.lastmodifiedby = ' + @userid
)
	
exec
(

'insert into #tblResults
	select
		distinct t.EMailLogID as fieldid,
		''email'' as type,
		t.CreatedDate as [date],
		tblclient.clientid,
		tblperson.firstname + '' '' + tblperson.lastname as [client],
		t.[MailSubject] as message,
		substring(t.[MailSubject], 0, ' + @shortvalue + ') + ''...'' as shortmessage,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedby,		
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,		
		t.CreatedBy
	from
		tblEmailRelayLog t  with(nolock) inner join
		tblclient  with(nolock) on t.clientid = tblclient.clientid inner join
		tblperson  with(nolock) on tblclient.primarypersonid = tblperson.personid left outer join
		tbluser as tblcreatedby  with(nolock) on t.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby  with(nolock) on t.createdby = tbllastmodifiedby.userid left outer join
		tblEmailRelayRelation rl  with(nolock) on t.EMailLogID = rl.EMailLogID left outer join 
		tblrelationtype rt  with(nolock) on rt.relationtypeid = rl.relationtypeid left outer join
		tblmatter mtr  with(nolock) on rl.relationid=mtr.matterid left outer join
		tblclient ct  with(nolock) on rl.relationid=ct.clientid
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
GO



