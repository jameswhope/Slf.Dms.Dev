/****** Object:  StoredProcedure [dbo].[stp_GetCommunicationForClient]    Script Date: 11/19/2007 15:27:07 ******/
DROP PROCEDURE [dbo].[stp_GetCommunicationForClient]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetCommunicationForClient]
	(
		@returntop varchar (50) = '100 percent',
		@clientid int,
		@shortvalue int = 150,
		@criteria varchar (8000) = '1=1',
		@userid int = null
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
userid int
)

exec
(
'insert into #tblResults 
	select
		distinct tblNote.NoteId As FieldId, 
		''note'' as type,
		tblnote.lastmodified as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblnote.[value] as message,
		substring(tblnote.[value], 0, ' + @shortvalue + ') + (case when len(tblnote.[value]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		null as direction,
		tblnote.createdby
	from
		tblnote left outer join
		tbluser as tbllastmodifiedby on tblnote.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug on ug.usergroupid = tblnote.usergroupid
	where
		(tblnote.clientid = ' + @clientid + ') and (' + @criteria + ')'
)

exec
(
'insert into #tblResults 
	select 
		distinct tblphonecall.PhoneCallId As FieldId, 
		''phonecall'' as type,
		tblphonecall.lastmodified as [date],
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname + '' </br> '' + ug.name as [by],
		tblphonecall.[subject] as message,
		substring(tblphonecall.[subject], 0, ' + @shortvalue + ') + (case when len(tblphonecall.[subject]) >= ' + @shortvalue + ' then ''...'' else '''' end) as shortmessage, 
		tblphonecall.direction,
		tblphonecall.createdby
	from
		tblphonecall left outer join
		tbluser as tbllastmodifiedby on tblphonecall.lastmodifiedby = tbllastmodifiedby.userid
		inner join tblusergroup as ug on ug.usergroupid = tblphonecall.usergroupid
	where
		tblphonecall.clientid=' + @clientid + ' and (' + @criteria + ')'
)

if @returntop='100 percent' begin
	select distinct
		* 
	from 
		#tblResults 
	where 
		userid=isnull(@userid,userid)
	order by 
		date desc, 
		fieldid desc
end else begin
	declare @amt int
	set @amt=convert(int,@returntop)
	set rowcount @amt
	select distinct
		* 
	from 
		#tblResults 
	where 
		userid=isnull(@userid,userid)
	order by 
		date desc, 
		fieldid desc
end



drop table #tblResults
GO
