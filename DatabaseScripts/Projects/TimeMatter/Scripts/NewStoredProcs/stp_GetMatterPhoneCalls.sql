set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*
      Revision    : <02 - 16 December 2009>
      Category    : [TimeMatter]
      Type        : {New}
      Decription : Returns Phones of Matters
*/
CREATE procedure [dbo].[stp_GetMatterPhoneCalls]
	(
		@matterid int,
		@clientid int = null,
		@relationid int = null,
		@relationtypeid int = null,
		@orderby varchar(50)='u.lastname asc',
		@clientonly bit=0
	)

as

declare @relationcriteria varchar(1000)

if @clientonly=1 begin
	set @relationcriteria = ' and not exists (select phonecallrelationid from tblphonecallrelation npcr where npcr.phonecallid=pc.phonecallid and not npcr.relationtypeid=1)'
end else begin
	set @relationcriteria = 'and not exists (select phonecallrelationid from tblphonecallrelation npcr where npcr.phonecallid=pc.phonecallid and not npcr.relationtypeid=19)'
end

declare @sql varchar(5000)

set @sql='
	select 
		pc.phonecallid,
		pc.personid,
		pc.userid,
		pc.clientid,
		pc.phonenumber,
		pc.direction,
		pc.subject,
		pc.body,
		pc.starttime,
		pc.endtime,
		p.firstname + '' '' + p.lastname as person,
		p.lastname as personlastname,
		u.firstname + '' '' + u.lastname + ''</br>'' + ug.Name as [by] , 
		u.lastname as bylastname,
		tblcreatedby.firstname + '' '' + tblcreatedby.lastname as createdbyname,
		tbllastmodifiedby.firstname + '' '' + tbllastmodifiedby.lastname as lastmodifiedbyname,
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
		tblphonecall pc left outer join
		tblperson p on pc.personid = p.personid left outer join
		tbluser u on pc.userid = u.userid left outer join
		tblusertype ut on u.usertypeid=ut.usertypeid left outer join
		tbluser as tblcreatedby on pc.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on pc.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tblrulecommcolor tc on u.usertypeid=tc.entityid and tc.entitytype=''User Type'' left outer join
		tblrulecommcolor gc on u.usergroupid=gc.entityid and gc.entitytype=''User Group'' left outer join
		tblrulecommcolor uc on u.userid=uc.entityid and uc.entitytype=''User'' left outer join
		(
			select
				npc.phonecallid,
				max(color) as color,
				max(textcolor) as textcolor
			from
				tblphonecallrelation pcr 
				inner join tblphonecall npc on pcr.phonecallid=npc.phonecallid
				inner join tblrulecommcolor rcc on rcc.entityid=pcr.relationtypeid
			where
				pcr.relationID=' + convert(varchar, @matterid) + '
				and rcc.entitytype=''Relation Type''
			group by
				npc.phonecallid
		) rc on rc.phonecallid=pc.phonecallid
		inner join tblusergroup as ug on ug.usergroupid = pc.usergroupid
	'

	set @sql=@sql + 
		' left outer join tblphonecallrelation pcr on pc.phonecallid=pcr.phonecallid'

set @sql = @sql +
	' where 
		pcr.relationID=' + convert(varchar,@matterid) 

	set @sql = @sql + 
		' and pcr.relationtypeid=19 '

set @sql = @sql + 
	' order by ' + 
		@orderby

exec(@sql)

select 
	pc.phonecallid,
	pcr.relationtypeid,
	pcr.relationid,
	rt.name as relationtypename,
	dbo.getentitydisplay(rt.relationtypeid,relationid) as relationname,
	rt.iconurl,
	rt.navigateurl
from
	tblphonecallrelation pcr inner join
	tblphonecall pc on pcr.phonecallid=pc.phonecallid inner join
	tblrelationtype rt on pcr.relationtypeid=rt.relationtypeid
where 
	pcr.relationtypeid=19 and pcr.relationID=@matterID




