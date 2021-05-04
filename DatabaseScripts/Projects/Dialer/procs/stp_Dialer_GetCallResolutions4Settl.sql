IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetCallResolutions4Settl')
	BEGIN
		DROP  Procedure  stp_Dialer_GetCallResolutions4Settl
	END

GO

CREATE Procedure stp_Dialer_GetCallResolutions4Settl
@CallMadeId int
AS
Begin

Declare @r as Table(CallResolutionId int, Created datetime, CreatedBy int, LastModified datetime, LastModifiedBy int, RecordingId int, TaskId int)

insert into @r(CallResolutionId, Created, CreatedBy, LastModified, LastModifiedBy, RecordingId, TaskId)
select CallResolutionId, Created, CreatedBy, LastModified, LastModifiedBy, RecordingId, TaskId = Cast(FieldValue as int) 
--Into #resolution
from tblDialerCallResolution  
where CallmadeId = @CallMadeId
and reasonid = 1

Select 
r.CallResolutionId,
s.SettlementID,
c.Name AS [Creditor Name],
--s.CreditorAccountBalance,
--s.CreditorAccountID,
--s.SettlementAmount,
--s.SettlementPercent,
--s.SettlementSavings,
--s.SettlementFee,
--s.OvernightDeliveryAmount,
--s.DeliveryMethod,
--s.SettlementCost,
--s.SettlementDueDate,
--s.Status,
r.created,
r.createdby,
r.lastmodified,
r.lastmodifiedby,
ci.accountnumber as CreditorAccountNumber,
t.due,
t.resolved,
t.resolvedby,
isnull(u.firstname,'') + ' ' +  isnull(u.lastname,'') as [ResolvedbyUser],
t.taskid,
t.assignedto,
t.taskresolutionid,
isnull(rs.[Name],'') as [TaskResolution],
a.originalAmount,
m.matterid,
ss.MatterSubStatus as [MatterSubStatus],
RecId=isnull(rc.recid,0),
RecFile=isnull(rc.RecFile,'')
--From #resolution r
From @r r
inner join tbltask t on t.taskid = r.taskid
inner join tblMatterTask mt ON mt.TaskId = t.TaskId 
inner join tblMatter m ON m.MatterId = mt.MatterId 
inner join tblSettlements s on s.MatterId = m.MatterId
inner join tblAccount as a on a.AccountID = s.CreditorAccountID
inner join tblCreditorInstance as ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID
inner join tblCreditor as c on c.CreditorID = ci.CreditorID
left join tbltaskresolution rs on rs.taskresolutionid = t.taskresolutionid 
left join tbluser u on u.userid = t.resolvedby 
left join tblcallrecording rc on rc.recid = r.recordingid
left join tblmattersubstatus ss on ss.MatterSubStatusId = m.MatterSubStatusId
--Where CallMadeId = @CallMadeId
--Order By r.CallResolutionId

--drop table #resolution

End

GO



