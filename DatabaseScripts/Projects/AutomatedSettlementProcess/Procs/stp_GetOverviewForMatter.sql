IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetOverviewForMatter')
	BEGIN
		DROP  Procedure  stp_GetOverviewForMatter
	END

GO

CREATE Procedure [dbo].[stp_GetOverviewForMatter]
	(
		@returntop varchar (50) = '100 percent',
		@matterid int,
		@shortvalue int = 150,
		@criteria varchar (8000) = '1=1',
		@userid int = null,
		@type varchar(100) = 'type=''task'' OR type=''note'' OR type=''email'' OR type=''phonecall''',
		@OrderBy varchar(100)='date Desc, fieldid Desc'
	)

as

--create our results table
create table #tblResults
(fieldid int,
[type] varchar(20),
[date] datetime,
[by] varchar(255),
message varchar(5000),
shortmessage varchar(5000),
direction bit,
userid int,
starttime datetime,
endtime datetime
)

exec
(
'insert into #tblResults 
	select 
		tbltask.taskid as fieldid,
		''task'' as type,
		tbltask.created as [date],
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as [by],
		tbltask.[Description] as message,
		substring(tbltask.[Description], 0, ' + @shortvalue + ') + (case when len(tbltask.[Description]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		null as direction,
		tbltask.createdby, null as starttime, null as endtime
	from
		tbltask with(nolock) left outer join
		tbluser as tblcreatedby with(nolock) on tbltask.createdby = tblcreatedby.userid
		left outer join	tblmattertask nr with(nolock) on tbltask.taskid=nr.taskid left outer join 
		tblmatter mtr with(nolock) on nr.matterid=mtr.matterid left outer join
		tblclient ct with(nolock) on mtr.clientid=ct.clientid
	where
		mtr.matterid = ' + @matterid + ' 		
'
)


exec
(
'insert into #tblResults 
	SELECT 	
		distinct Notestbl.noteid as fieldid,	
		''note'' as type,
		n.lastmodified as [date],
		u.firstname + '' '' + u.lastname + '' </br> '' + ug.name as [by],
		n.[value] as message,
		substring(n.[value], 0, ' + @shortvalue + ') + (case when len(n.[value]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		null as direction,
		n.createdby, 
		null as starttime, 
		null as endtime
FROM
		(SELECT    
			distinct nr.NoteId		
		FROM   
			tblNoteRelation nr with(nolock)		
		WHERE
			nr.RelationId = ' + @matterid + ' and nr.relationTypeId = 19 

		UNION

		SELECT    
			distinct NoteId		
		FROM    
			tbltasknote tn with(nolock) inner join
			tblmattertask mt with(nolock) on mt.taskid=tn.taskid and mt.matterid= ' + @matterid + '
	) Notestbl inner join
	tblnote n with(nolock) on n.NoteId = Notestbl.NoteId inner join
	tbluser as u with(nolock) on n.CreatedBy = u.userid inner join 
	tblusergroup as ug with(nolock) on ug.usergroupid = u.usergroupid 
'
)

exec 
(
'insert into #tblResults 
	select 
		tblEmailRelayLog.EMailLogID as fieldid,
		''email'' as type,
		tblEmailRelayLog.CreatedDate as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblEmailRelayLog.[MailSubject] as message,
		substring(tblEmailRelayLog.[MailSubject], 0, ' + @shortvalue + ') + (case when len(tblEmailRelayLog.[MailSubject]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		null as direction,
		tblEmailRelayLog.createdby, null as starttime, null as endtime
	from
		tblEmailRelayLog with(nolock) left outer join
		tbluser as tbllastmodifiedby with(nolock) on tblEmailRelayLog.createdby = tbllastmodifiedby.userid
		inner join tblusergroup as ug with(nolock) on ug.usergroupid = tblEmailRelayLog.usergroupid left outer join
		tblEmailRelayRelation rl with(nolock) on tblEmailRelayLog.EMailLogID = rl.EMailLogID left outer join 
		tblrelationtype rt with(nolock) on rt.relationtypeid = rl.relationtypeid left outer join
		tblmatter mtr with(nolock) on rl.relationid=mtr.matterid left outer join
		tblclient ct with(nolock) on rl.relationid=ct.clientid
	where
		rl.relationtypeid=19 and rl.relationid = ' + @matterid + '
'
)

exec
(
'insert into #tblResults 
	select 
		tblphonecall.phonecallid as fieldid,
		''phonecall'' as type,
		tblphonecall.lastmodified as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblphonecall.[subject] as message,
		substring(tblphonecall.[subject], 0, ' + @shortvalue + ') + (case when len(tblphonecall.[subject]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		tblphonecall.direction,
		tblphonecall.createdby , tblphonecall.starttime, tblphonecall.endtime
	from
		tblphonecall with(nolock) left outer join
		tbluser as tbllastmodifiedby with(nolock) on tblphonecall.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug with(nolock) on ug.usergroupid = tblphonecall.usergroupid left outer join
		tblphonecallrelation pr with(nolock) on tblphonecall.phonecallid=pr.phonecallid left outer join 
		tblrelationtype rt with(nolock) on rt.relationtypeid = pr.relationtypeid left outer join 
		tblmatter mtr with(nolock) on pr.relationid=mtr.matterid left outer join
		tblclient ct with(nolock) on pr.relationid=ct.clientid
	where
		pr.relationtypeid=19 and pr.relationid = ' + @matterid + ' 
'
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
	order by ' + @OrderBy +' ')


end else begin
	exec
(
'select top ' + @returntop + '
		* 
	from 
		#tblResults 
	where 
		 '+ @type + ' 
	order by ' + @OrderBy +' ')
end

drop table #tblResults
GO

GRANT EXEC ON stp_GetOverviewForMatter TO PUBLIC

GO


