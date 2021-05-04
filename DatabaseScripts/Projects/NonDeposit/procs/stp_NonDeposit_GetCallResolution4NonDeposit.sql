IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetCallResolutions4NonDeposit')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetCallResolutions4NonDeposit
	END

GO

CREATE Procedure stp_NonDeposit_GetCallResolutions4NonDeposit
@CallMadeId int
AS
Begin

Declare @r as Table(CallResolutionId int, Created datetime, CreatedBy int, LastModified datetime, LastModifiedBy int, TaskId int)

insert into @r(CallResolutionId, Created, CreatedBy, LastModified, LastModifiedBy, TaskId)
select CallResolutionId, Created, CreatedBy, LastModified, LastModifiedBy, TaskId = Cast(FieldValue as int) 
--Into #resolution
from tblDialerCallResolution  
where CallmadeId = @CallMadeId
and reasonid in (2,3)

Select 
r.CallResolutionId,
n.NonDepositId,
r.created,
r.createdby,
r.lastmodified,
r.lastmodifiedby,
n.NonDepositTypeId,
p.ShortDescription as NonDepositType,
t.resolved,
t.resolvedby,
isnull(u.firstname,'') + ' ' +  isnull(u.lastname,'') as [ResolvedbyUser],
t.taskid,
t.assignedto,
t.taskresolutionid,
isnull(rs.[Name],'') as [TaskResolution],
m.matterid,
ss.MatterSubStatus as [MatterSubStatus],
[DepositDate] = case n.NonDepositTypeId when 1 then n.MissedDate else (Select r.transactiondate from tblregister r where r.registerid = n.DepositId) end,
[BouncedDate] = (Select r.bounce from tblregister r where r.registerid = n.DepositId),
[BouncedReason] = isnull((Select rs.bounceddescription from tblregister r inner join tblbouncedreasons rs on rs.bouncedid = r.bouncedreason where r.registerid = n.DepositId),''),
[DepositAmount] = case n.NonDepositTypeId when 1 then n.DepositAmount else (Select r.amount from tblregister r where r.registerid = n.DepositId) end,
n.DepositId,
m.MatterNumber
From @r r
inner join tbltask t on t.taskid = r.taskid
inner join tblMatterTask mt ON mt.TaskId = t.TaskId 
inner join tblMatter m ON m.MatterId = mt.MatterId 
inner join tblNonDeposit n on n.MatterId = m.MatterId
inner join tblNonDepositType p on n.NonDepositTypeId  = p.NonDepositTypeId
left join tbltaskresolution rs on rs.taskresolutionid = t.taskresolutionid 
left join tbluser u on u.userid = t.resolvedby 
left join tblmattersubstatus ss on ss.MatterSubStatusId = m.MatterSubStatusId

End