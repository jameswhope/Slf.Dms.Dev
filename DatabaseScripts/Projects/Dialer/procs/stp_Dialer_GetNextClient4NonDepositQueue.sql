IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Dialer_GetNextClient4NonDepositQueue')
	BEGIN
		DROP  Procedure  stp_Dialer_GetNextClient4NonDepositQueue
	END

GO

CREATE Procedure stp_Dialer_GetNextClient4NonDepositQueue
AS
Select Top 1
	m.ClientId
FROM 
	tblTask t inner join
	tblMatterTask mt ON mt.TaskId = t.TaskId inner join
	tblMatter m ON m.MatterId = mt.MatterId and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) inner join
	tblNonDeposit n ON n.MatterId = m.MatterId inner join
	tblClient c ON c.ClientId = m.ClientId  inner join
	tblPerson p ON p.clientId = c.clientId  inner join
	tblPersonPhone pp ON pp.PersonId = p.PersonId left join
	tblPhone ph ON ph.PhoneId = pp.PhoneId 	
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
	and not ((datediff(m, c.initialdraftdate, getdate()) < 7 and isnull(c.depositmethod,'Check') = 'ACH') or (datediff(m, c.created, getdate()) < 2 and isnull(c.depositmethod,'Check') <> 'ACH'))
Group by m.ClientId
Order By Max(n.LastModified) desc

GO
 

