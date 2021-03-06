set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*
      Revision    : <03 - 28 January 2010>
      Category    : [TimeMatter]
      Type        : {New}
      Description : Retrives the details for matter road map
*/
CREATE procedure [dbo].[stp_GetMatterAudit]
@MatterID as int=0
as 
select 1 as seq, 0 as taskid, null as resolved,
 ma.fieldname as [description], null as due , u.firstname+' '+u.lastname Createdbyname,   ma.updatedate as created,
case fieldname when 'MatterStatusCodeId' then  
(select matterStatusCode as oldfieldvalue from tblMatterStatusCode where matterstatuscodeid=oldvalue) +'-->'+
(select matterStatusCode as newfieldvalue from tblMatterStatusCode where matterstatuscodeid=newvalue)
when 'AttorneyId' then  
(select  FirstName +' '+Lastname as oldfieldvalue from tblAttorney where attorneyid=oldvalue) +'-->'+
(select FirstName +' '+Lastname as newfieldvalue from tblAttorney where attorneyid=newvalue)
end as change
 from tblmatteraudit ma  
inner join tbluser u on ma.username=u.userid
 where replace(replace(pk,'<MatterId=',''),'>','')=@MatterID
 and Type='U' 

 union 
 
select 2 as seq,   tbltask.taskid, tbltask.Resolved,   tbltask.Description, tbltask.Due , 
		tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname ,tbltask.created, '' as change
		 	from
		tbltask left outer join
		tblclienttask on tbltask.taskid = tblclienttask.taskid left outer join
		tblclient on tblclienttask.clientid = tblclient.clientid left outer join
		tblperson on tblclient.primarypersonid = tblperson.personid left outer join
		tbltasktype on tbltask.tasktypeid = tbltasktype.tasktypeid left outer join
		tbltasktypecategory on tbltasktype.tasktypecategoryid = tbltasktypecategory.tasktypecategoryid left outer join
		tbltaskresolution on tbltask.taskresolutionid = tbltaskresolution.taskresolutionid left outer join
		tbluser as tblassignedto on tbltask.assignedto = tblassignedto.userid left outer join
		tbluser as tblresolvedby on tbltask.resolvedby = tblresolvedby.userid left outer join
		tbluser as tblcreatedby on tbltask.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on tbltask.lastmodifiedby = tbllastmodifiedby.userid
		left outer join tblmattertask on tblmattertask.taskid = tbltask.taskid	
		left outer join tblUserType as tblassignedtousertype on tblassignedtousertype.usertypeid =tblassignedto.usertypeid
		left outer join tbluserGroup as tblassignedtousergroup on tblassignedtousergroup.usergroupid = tblassignedto.usergroupid
	  WHERE tblmattertask.MatterID=@MatterID

union

	select 3 as seq, 0 as taskid, null as resolved, 		 
		n.value as description,null as due, 
		u.firstname + ' ' + u.lastname + '</br>' + ug.Name as createdbyname, 
	 
		n.created as created,
		ut.name as change 
	from 
		tblnote n left outer join
		tbluser u on n.createdby=u.userid left outer join
		tblusertype ut on u.usertypeid=ut.usertypeid left outer join
		tblrulecommcolor tc on u.usertypeid=tc.entityid and tc.entitytype='User Type' left outer join
		tblrulecommcolor gc on u.usergroupid=gc.entityid and gc.entitytype='User Group' left outer join
		tblrulecommcolor uc on u.userid=uc.entityid and uc.entitytype='User' left outer join
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
				nr.relationid=@matterid
				and rcc.entitytype='Relation Type'
			group by
				nn.noteid
		) rc on rc.noteid=n.noteid
		inner join tblusergroup as ug on ug.usergroupid = n.usergroupid
	 left outer join tblnoterelation nr on n.noteid=nr.noteid  
  where 
		nr.relationid= @matterid  and nr.relationtypeid=19 

union

select  4 as seq, 0 as taskid , pc.endtime as resolved,
pc.subject+':'+pc.body +'->'+p.firstname + ' ' + p.lastname  as description,null as due, 
tblcreatedby.firstname + ' ' + tblcreatedby.lastname as createdbyname,pc.starttime as  created,
case pc.direction when 1 then 'out' else 'in' end  change
	from 	tblphonecall pc left outer join
		tblperson p on pc.personid = p.personid left outer join
		tbluser u on pc.userid = u.userid left outer join
		tblusertype ut on u.usertypeid=ut.usertypeid left outer join
		tbluser as tblcreatedby on pc.createdby = tblcreatedby.userid left outer join
		tbluser as tbllastmodifiedby on pc.lastmodifiedby = tbllastmodifiedby.userid left outer join
		tblrulecommcolor tc on u.usertypeid=tc.entityid and tc.entitytype='User Type' left outer join
		tblrulecommcolor gc on u.usergroupid=gc.entityid and gc.entitytype='User Group' left outer join
		tblrulecommcolor uc on u.userid=uc.entityid and uc.entitytype='User' left outer join
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
				pcr.relationID= @matterid
				and rcc.entitytype='Relation Type'
			group by
				npc.phonecallid
		) rc on rc.phonecallid=pc.phonecallid
		inner join tblusergroup as ug on ug.usergroupid = pc.usergroupid
	  left outer join tblphonecallrelation pcr on pc.phonecallid=pcr.phonecallid 
  where pcr.relationID=@matterid and pcr.relationtypeid=19  

union 

SELECT  5 as seq, dr.DocRelationID as taskid , null as resolved, dt.DisplayName as description, isnull(ds.ReceivedDate, '01/01/1900') as due,  
isnull(u.FirstName + ' ' + u.LastName + '</br>' + ug.Name, '') as createdbyname,
isnull(dr.RelatedDate, '01/01/1900') as Created, 
--isnull(ds.Created, '01/01/1900') as Created, 
case deletedflag when 1 then 'Deleted' else '' end as  change FROM tblDocRelation as dr inner join tblDocumentType as dt  
on dt.TypeID = dr.DocTypeID left join tblDocScan as ds on ds.DocID = dr.DocID left join tblUser as u on u.UserID = dr.RelatedBy inner join tblusergroup as ug on ug.usergroupid = u.usergroupid  
WHERE dr.RelationID =@MatterID and dr.RelationType = 'matter' and (DeletedFlag = 0 or DeletedBy = -1)  
 

union

	select 6 as seq, 0 as taskid, null as resolved, 		 
		n.MailSubject as description,null as due, 
		u.firstname + ' ' + u.lastname + '</br>' + ug.Name as createdbyname, 
	 
		n.createdDate as created,
		ut.name as change 
	from 
		tblEmailRelayLog n left outer join
		tbluser u on n.createdby=u.userid left outer join
		tblusertype ut on u.usertypeid=ut.usertypeid left outer join
		tblrulecommcolor tc on u.usertypeid=tc.entityid and tc.entitytype='User Type' left outer join
		tblrulecommcolor gc on u.usergroupid=gc.entityid and gc.entitytype='User Group' left outer join
		tblrulecommcolor uc on u.userid=uc.entityid and uc.entitytype='User' left outer join
		(
			select
				nn.EMailLogID,
				max(color) as color,
				max(textcolor) as textcolor
			from
				tblEmailRelayRelation nr 
				inner join tblEmailRelayLog nn on nr.EMailLogID=nn.EMailLogID
				inner join tblrulecommcolor rcc on rcc.entityid=nr.relationtypeid
			where
				nr.relationid=@matterid
				and rcc.entitytype='Relation Type'
			group by
				nn.EMailLogID
		) rc on rc.EMailLogID=n.EMailLogID
		inner join tblusergroup as ug on ug.usergroupid = n.usergroupid
	 left outer join tblEmailRelayRelation nr on n.EMailLogID=nr.EMailLogID  
  where 
		nr.relationid= @matterid  and nr.relationtypeid=19 
order by created






