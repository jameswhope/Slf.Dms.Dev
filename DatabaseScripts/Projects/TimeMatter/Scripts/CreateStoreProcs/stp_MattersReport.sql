IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_MattersReport')
		DROP  Procedure  stp_MattersReport
GO 

create procedure stp_MattersReport
(
	@criteria varchar(2000) = ''
)
as

exec('
select distinct t.TaskID, m.MatterID, t.Due, t.TaskResolutionID, t.Description, t.Resolved, m.MatterTypeId,
	cast(convert(varchar(10),t.Created,101) as datetime) [created],
	g.name [Creditor], 
	''**'' + right(ci.accountnumber,4) [last4],
	c.accountnumber, p.firstname + '' '' + p.lastname [Client], 
	Case t.TaskTypeID When 0 Then ''Ad Hoc'' Else tt.name end [TaskType],
	a.firstname + '' '' + a.lastname [AssignedTo],
	cb.firstname + '' '' + cb.lastname [CreatedBy],
	ms.matterstatus,
	cp.shortconame [company],
	ag.name [assignedtogroup],
	m.clientid, 
	isnull(ci.accountid,-1)[accountid], 
	isnull(ci.creditorid,-1)[creditorid], 
	isnull(ci.creditorinstanceid,-1)[creditorinstanceid],
	isnull(m.mattertypeid,-1)[mattertypeid],
	s.name[ClientState],
	ra.firstname + '' '' + ra.lastname [ResolvedBy],
	cl.classification[Matter Classification]
from tblmatter m with(nolock)
join tblmattertask mt with(nolock) on mt.matterid = m.matterid
join tbltask t with(nolock)  on t.taskid = mt.taskid
join tblclient c with(nolock)  on c.clientid = m.clientid
join tblperson p with(nolock)  on p.personId = c.primarypersonid
join tblcompany cp with(nolock)  on cp.companyid = c.companyid
left join tblcreditorinstance ci with(nolock)  on ci.creditorinstanceid = m.creditorinstanceid
left join tblcreditor cr with(nolock)  on cr.creditorid = ci.creditorid
left join tblcreditorgroup g with(nolock)  on g.creditorgroupid = cr.creditorgroupid
left join tbltasktype tt with(nolock)  on tt.tasktypeid = t.tasktypeid
left join tbluser a with(nolock)  on a.userid = t.assignedto
left join tblusergroup ag with(nolock)  on ag.usergroupid = t.assignedtogroupid
left join tbluser cb with(nolock)  on cb.userid = t.createdby
left join tblattorney at with(nolock)  on at.attorneyid = m.attorneyid
left join tblmatterstatus ms with(nolock)  on ms.matterstatusid = m.matterstatusid
inner join tblstate s with(nolock)  on p.stateid = s.stateid
left join tbluser ra with(nolock)  on ra.userid = t.resolvedby
left join tblmatterclassification mc on mc.matterid = m.matterid and mc.Deleted is NULL
inner join tblclassifications cl on cl.classificationid= mc.classificationid
where isnull(m.isdeleted,0) = 0
' + @criteria + '
order by t.Created 
OPTION (FAST 100) '
)