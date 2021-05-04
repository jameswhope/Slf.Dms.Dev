IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationNotesSelect')
	BEGIN
		DROP  Procedure  stp_NegotiationNotesSelect
	END

GO

CREATE Procedure stp_NegotiationNotesSelect
	(
		@clientid int,
		@relationid int = null,
		@relationtypeid int = null,
		@clientonly bit=0
	)


AS
declare @Noterelationcriteria varchar(1000)
declare @Phonerelationcriteria varchar(1000)

if @clientonly=1 begin
	set @Noterelationcriteria = ' and not exists (select noterelationid from tblnoterelation nnr where nnr.noteid=n.noteid and not nnr.relationtypeid=1)'
	set @Phonerelationcriteria = ' and not exists (select phonecallrelationid from tblphonecallrelation npcr where npcr.phonecallid=pc.phonecallid and not npcr.relationtypeid=1)'
end else begin
	set @Noterelationcriteria = ''
	set @Phonerelationcriteria = ''
end

declare @sql varchar(5000)

set @sql='
Select 
	[Type],[ID],isnull(subject,'''') as [subject] ,[Description],[by],bylastname,usertype,[date],personid,userid,clientid,phonenumber,direction,starttime,endtime,color,textcolor,Staff,CommDate,CommTime,CommTable
FROM 
	(select 
		''NOTE'' as [Type]
		,n.noteid as [ID]
		,n.subject 
		,n.value as [Description]
		,u.firstname + '' '' + u.lastname + char(13) + ug.name as [by]
		,u.lastname as bylastname 
		,ut.name as usertype
		,n.created as [date]
		,null as personid
		,u.userid
		,n.clientid
		,''''  as phonenumber
		,''''  as direction
		,''''  as starttime
		,''''  as endtime 
		,(case when not rc.color is null then rc.color when not uc.color is null then uc.color when not gc.color is null then gc.color when not tc.color is null then tc.color end ) as color 
		,(case when not rc.textcolor is null then rc.textcolor when not uc.textcolor is null then uc.textcolor when not gc.textcolor is null then gc.textcolor when not tc.textcolor is null then tc.textcolor end ) as textcolor 
		,'''' as Staff
		,'''' as CommDate
		,'''' as CommTime
		,'''' as CommTable
	from 
		tblnote n left outer join tbluser u 
		on n.createdby=u.userid left outer join tblusertype ut 
		on u.usertypeid=ut.usertypeid left outer join tblrulecommcolor tc 
		on u.usertypeid=tc.entityid and tc.entitytype=''User Type'' left outer join tblrulecommcolor gc 
		on u.usergroupid=gc.entityid and gc.entitytype=''User Group'' left outer join tblrulecommcolor uc 
		on u.userid=uc.entityid and uc.entitytype=''User'' left outer join 
		(select nn.noteid, max(color) as color,max(textcolor) as textcolor 
		from tblnoterelation nr inner join tblnote nn on nr.noteid=nn.noteid inner join tblrulecommcolor rcc on rcc.entityid=nr.relationtypeid 
		where nn.clientid='+ convert(varchar,@clientid) + ' and rcc.entitytype=''Relation Type'' group by nn.noteid ) rc on rc.noteid=n.noteid 
		inner join tblusergroup as ug on ug.usergroupid = u.usergroupid '

if not @relationid is null begin
	set @sql=@sql + ' left outer join tblnoterelation nr on n.noteid=nr.noteid'
end

set @sql = @sql + ' where n.clientid=' + convert(varchar,@clientid) + @Noterelationcriteria 

if not @relationid is null begin
	set @sql = @sql + ' and nr.relationtypeid=' + convert(varchar,@relationtypeid) + ' and nr.relationid=' + convert(varchar,@relationid)
end

set @sql = @sql + ' union '

set @sql = @sql + '
	select 
		''PHONE'' as [Type]
		,pc.phonecallid as [ID]
		,pc.subject
		,pc.body as [Description]
		,u.firstname + '' '' + u.lastname + char(13) + ug.name as [by]
		, u.lastname as bylastname 
		,ut.name as usertype
		, pc.created as [date]
		,pc.personid
		,pc.userid
		,pc.clientid
		,pc.phonenumber
		,pc.direction
		,pc.starttime
		,pc.endtime 
		,(case when not rc.color is null then rc.color when not uc.color is null then uc.color when not gc.color is null then gc.color when not tc.color is null then tc.color end ) as color 
		,(case when not rc.textcolor is null then rc.textcolor when not uc.textcolor is null then uc.textcolor when not gc.textcolor is null then gc.textcolor when not tc.textcolor is null then tc.textcolor end ) as textcolor 
		,'''' as Staff
		,'''' as CommDate
		,'''' as CommTime
		,'''' as CommTable
	from tblphonecall pc left outer join tblperson p 
	on pc.personid = p.personid left outer join tbluser u 
	on pc.userid = u.userid left outer join tblusertype ut 
	on u.usertypeid=ut.usertypeid left outer join tbluser as tblcreatedby 
	on pc.createdby = tblcreatedby.userid left outer join tbluser as tbllastmodifiedby 
	on pc.lastmodifiedby = tbllastmodifiedby.userid left outer join tblrulecommcolor tc 
	on u.usertypeid=tc.entityid and tc.entitytype=''User Type'' left outer join tblrulecommcolor gc 
	on u.usergroupid=gc.entityid and gc.entitytype=''User Group'' left outer join tblrulecommcolor uc 
	on u.userid=uc.entityid and uc.entitytype=''User'' left outer join 
	(
		select 
			npc.phonecallid
			,max(color) as color
			,max(textcolor) as textcolor 
		from tblphonecallrelation pcr inner join tblphonecall npc 
			on pcr.phonecallid=npc.phonecallid inner join tblrulecommcolor rcc 
			on rcc.entityid=pcr.relationtypeid 
		where 
			npc.clientid='+ convert(varchar,@clientid) + ' 
			and rcc.entitytype=''Relation Type'' 
		group by npc.phonecallid) rc on rc.phonecallid=pc.phonecallid 
		inner join tblusergroup as ug on ug.usergroupid = u.usergroupid '
if not @relationid is null begin
	set @sql=@sql + ' left outer join tblphonecallrelation pcr on pc.phonecallid=pcr.phonecallid '
end
set @sql = @sql + ' where pc.clientid=' + convert(varchar,@clientid) + @Phonerelationcriteria 

if not @relationid is null begin
	set @sql = @sql + ' and pcr.relationtypeid=' + convert(varchar,@relationtypeid) + ' and pcr.relationid=' + convert(varchar,@relationid)
end

set @sql = @sql + ') as CommData Order By [date] desc'

exec(@sql)



GO


GRANT EXEC ON stp_NegotiationNotesSelect TO PUBLIC

GO


