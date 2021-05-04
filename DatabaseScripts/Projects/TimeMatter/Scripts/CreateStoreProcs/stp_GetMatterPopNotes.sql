IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetMatterPopNotes')
	BEGIN
		DROP  Procedure  stp_GetMatterPopNotes
	END

GO

create procedure [dbo].[stp_GetMatterPopNotes]  
 (  
  @matterId int,  
  @clientid int = null,  
  @relationid int = null,  
  @relationtypeid int = null,  
  @orderby varchar(50)='bylastname asc',  
  @clientonly bit=0  
 )  
  
as  
  
declare @relationcriteria varchar(1000)  
  
if @clientonly=1 begin  
 set @relationcriteria = ' and not exists (select noterelationid from tblnoterelation nnr where nnr.noteid=n.noteid and not nnr.relationtypeid=1)'  
end else begin  
 set @relationcriteria = ' and not exists (select noterelationid from tblnoterelation nnr where nnr.noteid=n.noteid and not nnr.relationtypeid=19)'  
end  
  
declare @sql varchar(5000)  
  
set @sql='select noteid,[subject],value,[by],bylastname,[date],usertype,color,textcolor,relationtypeid,relationid,relationtypename,relationname,iconurl,navigateurl from (    
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
   ,nr.relationtypeid,  
  nr.relationid,  
  rt.name as relationtypename,  
  dbo.getentitydisplay(rt.relationtypeid,relationid) as relationname,  
  rt.iconurl,  
  rt.navigateurl   
 from   
  tblnote n left outer join  
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
    tblnoterelation nr   
    inner join tblnote nn on nr.noteid=nn.noteid  
    inner join tblrulecommcolor rcc on rcc.entityid=nr.relationtypeid  
   where  
    nr.relationid=' + convert(varchar,@matterid) + '  
    and rcc.entitytype=''Relation Type''  
   group by  
    nn.noteid  
  ) rc on rc.noteid=n.noteid  
  inner join tblusergroup as ug on ug.usergroupid = n.usergroupid  
 '  
 set @sql=@sql +   
  ' left outer join tblnoterelation nr on n.noteid=nr.noteid 
	inner join tblrelationtype rt on nr.relationtypeid=rt.relationtypeid  '  
  
set @sql = @sql +  
 ' where   
  nr.relationid=' + convert(varchar,@matterid)   
  
 set @sql = @sql +   
  ' and nr.relationtypeid=19 '  

set @sql = @sql +  ' UNION 

select  
  n.noteid,  
  n.subject,  
  n.value,  
  u.firstname + '' '' + u.lastname as [by],   
  u.lastname as bylastname,   
  n.created as [date],  
  '''' as usertype,  
  '''' as color,  
  '''' as textcolor,
  nr.relationtypeid,  
  nr.relationid,  
  rt.name as relationtypename,  
  dbo.getentitydisplay(rt.relationtypeid,relationid) as relationname,  
  rt.iconurl,  
  rt.navigateurl    
 from   
  tblnote n left outer join  
  tbluser u on n.createdby=u.userid left outer join  
  tbltasknote tn on tn.noteid=n.noteid left outer join
  tblmattertask mt on mt.taskid=tn.taskid 
  inner join tblnoterelation nr on nr.noteid=n.noteid 
  inner join tblrelationtype rt on nr.relationtypeid=rt.relationtypeid  
  where nr.relationtypeid=19 and mt.matterid=' + convert(varchar,@matterid) + ' ) as noteData  '
  
if RTrim(LTrim(@orderby))<>'Unknown'  
set @sql = @sql +  ' order by ' +  @orderby  
exec(@sql)  


GO


GRANT EXEC ON stp_GetMatterPopNotes TO PUBLIC

GO


