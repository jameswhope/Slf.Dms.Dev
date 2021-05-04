IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextClient4SettlQueue')
	BEGIN
		DROP  Procedure  stp_Dialer_GetNextClient4SettlQueue
	END

GO

CREATE Procedure stp_Dialer_GetNextClient4SettlQueue
AS
begin
declare @clientid int set @clientid = null

Select 	 
top  1 @clientid = m.ClientId 
FROM 
	tblTask t inner join
	tblMatterTask mt ON mt.TaskId = t.TaskId inner join
	tblMatter m ON m.MatterId = mt.MatterId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) inner join
	tblSettlements s ON s.MatterId = m.MatterId and s.Active = 1 inner join
	tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join
	tblCreditor cr ON cr.CreditorId = ci.CreditorId inner join
	tblClient c ON c.ClientId = m.ClientId  inner join
	tblPerson p ON p.clientId = c.clientId  inner join
	tblPersonPhone pp ON pp.PersonId = p.PersonId left join
	tblPhone ph ON ph.PhoneId = pp.PhoneId left join
	tblmatterdialerlog l  on m.matterid = l.matterid
WHERE 
	t.TaskTypeId = 72 
	and (t.TaskResolutionId is null or t.TaskResolutionId not in (1,2,3,4))
	and c.currentclientstatusid not in (15,16,17,18)
	and (c.dialerResumeAfter is null or c.DialerResumeAfter < getdate())
	and ph.PhoneId is not null 
	and ph.phonetypeid not in (23,29,33) -- all phones but faxes
	and ph.excludefromdialer = 0
	and GetDate() < DateAdd(d,1,SettlementDueDate) -- cant call after 
	and l.matterid is null 
Group by m.ClientId 
Order By Max(s.LastModified) desc

if @clientid is null
begin

	Select 	top  1 
		@clientid = m.ClientId 
	FROM 
		tblTask t inner join
		tblMatterTask mt ON mt.TaskId = t.TaskId inner join
		tblMatter m ON m.MatterId = mt.MatterId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) inner join
		tblSettlements s ON s.MatterId = m.MatterId and s.Active = 1 inner join
		tblCreditorInstance ci ON ci.CreditorInstanceId = m.CreditorInstanceId inner join
		tblCreditor cr ON cr.CreditorId = ci.CreditorId inner join
		tblClient c ON c.ClientId = m.ClientId  inner join
		tblPerson p ON p.clientId = c.clientId  inner join
		tblPersonPhone pp ON pp.PersonId = p.PersonId left join
		tblPhone ph ON ph.PhoneId = pp.PhoneId inner join
		--get last settlement date call and number of calls on that date
		(select sm.ClientId, CallDate=convert(varchar(10), sm.created, 101), sm.DayCallCount, sm.LastCallDate
		from tblDialerClientLogSummary sm inner join
		(select maxid=max(sm1.DialerClientLogId), sm1.clientid from tblDialerClientLogSummary sm1 where sm1.reasonid = 1
		group by sm1.clientid) s on s.maxid = sm.DialerClientLogId
		where sm.reasonid = 1) ml on ml.clientid = m.clientid
	WHERE 
		t.TaskTypeId = 72 
		and (t.TaskResolutionId is null or t.TaskResolutionId not in (1,2,3,4))
		and c.currentclientstatusid not in (15,16,17,18)
		and (c.dialerResumeAfter is null or c.DialerResumeAfter < getdate())
		and ph.PhoneId is not null 
		and ph.phonetypeid not in (23,29,33) -- all phones but faxes
		and ph.excludefromdialer = 0
		and GetDate() < DateAdd(d,1,SettlementDueDate) -- cant call after 
	Group by m.ClientId 
	Order By min(ml.calldate) asc, min(ml.DayCallCount), min(s.SettlementDueDate)
end
	
select @clientid as clientid where @clientid is not null

end
