IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNotesArchive')
		DROP  Procedure  stp_GetNotesArchive
GO

CREATE procedure [dbo].[stp_GetNotesArchive]
(
	@clientid int,
	@relationid int = null,
	@relationtypeid int = null,
	@orderby varchar(50) = 'u.lastname asc',
	@clientonly bit = 0
)
as
declare @relationcriteria varchar(1000)

if @clientonly=1 begin
	set @relationcriteria = ' and not exists (select noterelationid from dms_archive..tblnoterelation nnr where nnr.noteid=n.noteid and not nnr.relationtypeid=1)'
end else begin
	set @relationcriteria = ''
end

declare @sql varchar(5000)

set @sql='
	select
		n.noteid,
		n.subject,
		n.value,
		u.firstname + '' '' + u.lastname + ''</br>'' + ug.Name as [by], 
		u.lastname as bylastname, 
		n.created as [date],
		ut.name as usertype,
		(case
			when not rc.color is null then rc.color
			when not uc.color is null then uc.color			
			when not gc.color is null then gc.color
			when not tc.color is null then tc.color
		end ) as color,
		(case
			when not rc.textcolor is null then rc.textcolor
			when not uc.textcolor is null then uc.textcolor			
			when not gc.textcolor is null then gc.textcolor
			when not tc.textcolor is null then tc.textcolor
		end ) as textcolor
	from 
		dms_archive..tblnote n left outer join
		tbluser u on n.createdby=u.userid left outer join
		tblusertype ut on u.usertypeid=ut.usertypeid left outer join
		tblrulecommcolor tc on u.usertypeid=tc.entityid and tc.entitytype=''User Type'' left outer join
		tblrulecommcolor gc on u.usergroupid=gc.entityid and gc.entitytype=''User Group'' left outer join
		tblrulecommcolor uc on u.userid=uc.entityid and uc.entitytype=''User'' left outer join
		(
			select
				nn.noteid,
				max(color) as color,
				max(textcolor) as textcolor
			from
				dms_archive..tblnoterelation nr 
				inner join dms_archive..tblnote nn on nr.noteid=nn.noteid
				inner join tblrulecommcolor rcc on rcc.entityid=nr.relationtypeid
			where
				nn.clientid=' + convert(varchar,@clientid) + '
				and rcc.entitytype=''Relation Type''
			group by
				nn.noteid
		) rc on rc.noteid=n.noteid
		left outer join tblusergroup as ug on ug.usergroupid = n.usergroupid
	'

if not @relationid is null  
	set @sql=@sql + 
		' left outer join dms_archive..tblnoterelation nr on n.noteid=nr.noteid 
		  left outer join tblmatter mtr on nr.relationid=mtr.matterid and mtr.IsDeleted=0 
		'

set @sql = @sql +
	' where 
		n.clientid=' + convert(varchar,@clientid) + 
		@relationcriteria 

if not @relationid is null begin
	set @sql = @sql + 
		' and nr.relationtypeid=' + convert(varchar,@relationtypeid) + '
		and nr.relationid=' + convert(varchar,@relationid)
end

set @sql = @sql + 
	' order by ' + 
		@orderby

exec(@sql)

select 
	n.noteid,
	nr.relationtypeid,
	nr.relationid,
	rt.name as relationtypename,
	dbo.getentitydisplay(rt.relationtypeid,relationid) as relationname,
	rt.iconurl,
	rt.navigateurl
from
	dms_archive..tblnoterelation nr inner join
	dms_archive..tblnote n on nr.noteid=n.noteid inner join
	tblrelationtype rt on nr.relationtypeid=rt.relationtypeid
where 
	clientid=@clientid
GO
 