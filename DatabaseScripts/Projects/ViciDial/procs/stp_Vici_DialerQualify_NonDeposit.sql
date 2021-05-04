IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_DialerQualify_NonDeposit')
	BEGIN
		DROP  Procedure  stp_Vici_DialerQualify_NonDeposit
	END

GO

CREATE Procedure stp_Vici_DialerQualify_NonDeposit
@matterid int
AS
Begin
	Select m.clientid
	FROM 
		tblTask t 
		inner join tblMatterTask mt ON mt.TaskId = t.TaskId 
		inner join tblMatter m ON m.MatterId = mt.MatterId  
		inner join tblNonDeposit n ON n.MatterId = m.MatterId 
		inner join tblClient c ON c.ClientId = m.ClientId  
		left join  vw_ExcludeSeidemanNonDepositDialer v on c.clientid = v.clientid	
	WHERE 
		t.TaskTypeId in (76, 77) --Contact or recontact client
		and (t.TaskResolutionId is null or t.TaskResolutionId not in (1,2,3,4))
		and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) and m.mattertypeid = 5
		and c.currentclientstatusid not in (15,16,17,18)
		and (c.dialerResumeAfter is null or c.DialerResumeAfter < getdate())
		and (m.dialerRetryAfter is null or m.DialerRetryAfter < getdate())
		and v.clientid is null
		and m.matterid = @matterid
End

GO



