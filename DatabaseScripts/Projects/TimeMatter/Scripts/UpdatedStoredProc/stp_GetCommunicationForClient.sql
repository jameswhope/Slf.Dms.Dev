set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
/*
      Revision    : <02 - 17 January 2010>
      Category    : [TimeMatter]
      Type        : {Update}
      Decription  : Get All communications for the client
*/
ALTER procedure [dbo].[stp_GetCommunicationForClient]
	(
		@returntop varchar (50) = '100 percent',
		@clientid int,
		@shortvalue int = 150,
		@criteria varchar (8000) = '1=1',
		@userid int = null,
		@type varchar(100) = 'type=''note'' OR type=''email'' OR type=''phonecall'''
	)

as

--create our results table
create table #tblResults
([type] varchar(20),
[date] datetime,
[by] varchar(255),
message varchar(5000),
shortmessage varchar(5000),
fieldid int,
direction bit,
userid int
)

exec
(
'insert into #tblResults 
	select 
		''note'' as type,
		tblnote.lastmodified as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblnote.[value] as message,
		substring(tblnote.[value], 0, ' + @shortvalue + ') + (case when len(tblnote.[value]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, tblnote.noteid as fieldid,
		null as direction,
		tblnote.createdby
	from
		tblnote left outer join
		tbluser as tbllastmodifiedby on tblnote.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug on ug.usergroupid = tblnote.usergroupid left outer join
		tblnoterelation nr on tblnote.noteid=nr.noteid left outer join 
		tblrelationtype rt on rt.relationtypeid = nr.relationtypeid left outer join 
		tblmatter mtr on nr.relationid=mtr.matterid left outer join
		tblclient ct on nr.relationid=ct.clientid
	where
		(isnull(mtr.IsDeleted,0)=0) and (tblnote.clientid = ' + @clientid + ') and (' + @criteria + ')'
)

exec 
(
'insert into #tblResults 
	select 
		''email'' as type,
		tblEmailRelayLog.CreatedDate as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblEmailRelayLog.[MailSubject] as message,
		substring(tblEmailRelayLog.[MailSubject], 0, ' + @shortvalue + ') + (case when len(tblEmailRelayLog.[MailSubject]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, tblEmailRelayLog.EMailLogID as fieldid,
		null as direction,
		tblEmailRelayLog.createdby
	from
		tblEmailRelayLog left outer join
		tbluser as tbllastmodifiedby on tblEmailRelayLog.createdby = tbllastmodifiedby.userid
		inner join tblusergroup as ug on ug.usergroupid = tblEmailRelayLog.usergroupid left outer join
		tblEmailRelayRelation rl on tblEmailRelayLog.EMailLogID = rl.EMailLogID left outer join 
		tblrelationtype rt on rt.relationtypeid = rl.relationtypeid left outer join
		tblmatter mtr on rl.relationid=mtr.matterid left outer join
		tblclient ct on rl.relationid=ct.clientid
	where
		(isnull(mtr.IsDeleted,0)=0) and (tblEmailRelayLog.clientid = ' + @clientid + ') and (' + @criteria + ')'
)

exec
(
'insert into #tblResults 
	select 
		''phonecall'' as type,
		tblphonecall.lastmodified as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblphonecall.[subject] as message,
		substring(tblphonecall.[subject], 0, ' + @shortvalue + ') + (case when len(tblphonecall.[subject]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		tblphonecall.phonecallid as fieldid,
		tblphonecall.direction,
		tblphonecall.createdby
	from
		tblphonecall left outer join
		tbluser as tbllastmodifiedby on tblphonecall.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug on ug.usergroupid = tblphonecall.usergroupid left outer join
		tblphonecallrelation pr on tblphonecall.phonecallid=pr.phonecallid left outer join 
		tblrelationtype rt on rt.relationtypeid = pr.relationtypeid left outer join 
		tblmatter mtr on pr.relationid=mtr.matterid left outer join
		tblclient ct on pr.relationid=ct.clientid
	where
		(isnull(mtr.IsDeleted,0)=0) and (tblphonecall.clientid=' + @clientid + ') and (' + @criteria + ')'
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
		fieldid desc')


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
		fieldid desc')
end

drop table #tblResults




