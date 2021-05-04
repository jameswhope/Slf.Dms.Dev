 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_getLeads')
	BEGIN
		DROP  Procedure  stp_NonDeposit_getLeads
	END

GO

CREATE Procedure stp_NonDeposit_getLeads
@userid int = 0
AS
Begin
 --stp_NonDeposit_getLeads
 Select  
 m.ClientId,
 LeadId = min(l.leadapplicantId),
 LeadName = min(l.FullName),
 PhoneId = min(ph.phoneid),
 Phone = (Select top 1 AreaCode + Number from tblphone where phoneid = min(ph.phoneid)),
 LastCalled = min(cl.lastcalled),
 Rep = min(isnull(u.firstname,'')+' '+isnull(u.lastname,''))  
FROM 
	tblTask t inner join
	tblMatterTask mt ON mt.TaskId = t.TaskId inner join
	tblMatter m ON m.MatterId = mt.MatterId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) inner join
	tblNonDeposit n ON n.MatterId = m.MatterId inner join
	tblClient c ON c.ClientId = m.ClientId  inner join
	vw_leadapplicant_client w on w.clientid = c.clientid inner join
	tblleadapplicant l on l.leadapplicantid = w.leadapplicantid inner join
	tblPerson p ON p.clientId = c.clientId  inner join
	tblPersonPhone pp ON pp.PersonId = p.PersonId left join
	tblPhone ph ON ph.PhoneId = pp.PhoneId left join
	(select LastCalled = max(sm.lastcalldate), sm.clientid from tblDialerClientLogSummary sm
	 where sm.reasonid = 2 group by  sm.clientid) cl on cl.clientid = c.clientid left join
	 tbluser u on u.userid = l.repid
WHERE 
	t.TaskTypeId in (76, 77) --Contact or recontact client
	and (t.TaskResolutionId is null or t.TaskResolutionId not in (1,2,3,4))
	and c.currentclientstatusid not in (15,16,17,18)
	and (c.dialerResumeAfter is null or c.DialerResumeAfter < getdate())
	and (m.dialerRetryAfter is null or m.DialerRetryAfter < getdate())
	and m.mattertypeid = 5
	and ph.PhoneId is not null 
	and ph.phonetypeid not in (23,29,33) -- all phones but faxes
	and ph.excludefromdialer = 0
	and ((datediff(m, c.initialdraftdate, getdate()) < 7 and isnull(c.depositmethod,'Check') = 'ACH') or (datediff(m, c.created, getdate()) < 2 and isnull(c.depositmethod,'Check') <> 'ACH'))
	and (@userid = 0 or @userid = l.repid) 
Group by m.ClientId
Order By Max(n.LastModified) desc
end