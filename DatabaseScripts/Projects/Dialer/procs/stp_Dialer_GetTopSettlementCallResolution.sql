IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetTopSettlementCallResolution')
	BEGIN
		DROP  Procedure  stp_Dialer_GetTopSettlementCallResolution
	END

GO

CREATE Procedure stp_Dialer_GetTopSettlementCallResolution
@CallMadeId int
AS
Select top 1 m.matterid, ci.accountnumber, c.name as CreditorName from tbldialercallresolution r
inner join tbltask t on t.taskid = r.fieldvalue
inner join tblMatterTask mt ON mt.TaskId = t.TaskId 
inner join tblMatter m ON m.MatterId = mt.MatterId 
inner join tblSettlements s on s.MatterId = m.MatterId
inner join tblAccount as a on a.AccountID = s.CreditorAccountID
inner join tblCreditorInstance as ci on ci.CreditorInstanceID = a.CurrentCreditorInstanceID
inner join tblCreditor as c on c.CreditorID = ci.CreditorID
where r.callmadeid = @CallMadeId
and r.reasonid = 1

GO
 

