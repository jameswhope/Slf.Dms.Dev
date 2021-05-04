IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetMatterNotes')
	BEGIN
		DROP  Procedure  stp_GetMatterNotes
	END

GO

CREATE Procedure [dbo].[stp_GetMatterNotes]  
 (  
  @matterId int,  
  @clientid int = null,  
  @relationid int = null,  
  @relationtypeid int = null,  
  @orderby varchar(50)='u.lastname asc',  
  @clientonly bit=0  
 )  
  
as  
  
declare @sql varchar(5000)  
  
set @sql='  
 SELECT
  DISTINCT(Notestbl.NoteId),  
  n.subject,  
  n.value,  
  u.firstname + '' '' + u.lastname + '' </br>'' + ug.Name as [by],   
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
FROM
	(SELECT    
		distinct nr.NoteId,
		max(color) as color,  
		max(textcolor) as textcolor  
	from  
		tblnoterelation nr   
		inner join tblnote nn on nr.noteid=nn.noteid  
		inner join tblrulecommcolor rcc on rcc.entityid=nr.relationtypeid  
	where  
		nr.relationid=' + convert(varchar,@matterid) + '   and nr.relationTypeId = 19 
		and rcc.entitytype=''Relation Type''  
	group by  
		nr.noteid 
	
	UNION

	SELECT    
		distinct NoteId,
		'''' As color,
		'''' As textcolor	
	FROM    
		tbltasknote tn inner join
		tblmattertask mt on mt.taskid=tn.taskid and mt.matterid= ' + convert(varchar, @matterid) + '
	) Notestbl inner join
	tblNote n on n.NoteId = Notestbl.NoteId inner join
	tbluser u on n.createdby=u.userid inner join  
	tblUserGroup ug on ug.UserGroupId = u.UserGroupId inner join
	tblusertype ut on u.usertypeid=ut.usertypeid left join
	tblrulecommcolor tc on u.usertypeid=tc.entityid and tc.entitytype=''User Type'' left join
	tblrulecommcolor gc on u.usergroupid=gc.entityid and gc.entitytype=''User Group'' left join
	tblrulecommcolor uc on u.userid=uc.entityid and uc.entitytype=''User'' left join
	tblrulecommcolor rc on rc.entityid = Notestbl.NoteId 
 '
  
if RTrim(LTrim(@orderby))<>'Unknown'  
set @sql = @sql +  ' order by ' +  @orderby  
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
 tblnoterelation nr inner join  
 tblnote n on nr.noteid=n.noteid inner join  
 tblrelationtype rt on nr.relationtypeid=rt.relationtypeid  
where   
 nr.relationtypeid=19 and relationID=@matterID  
GO


GRANT EXEC ON stp_GetMatterNotes TO PUBLIC

GO


