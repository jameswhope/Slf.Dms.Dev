IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetNextLeadsToCall_Settlements')
	BEGIN
		DROP  Procedure  stp_Vici_GetNextLeadsToCall_Settlements
	END

GO

CREATE Procedure stp_Vici_GetNextLeadsToCall_Settlements
(
	@TopN int = 100
)
AS
BEGIN
declare @callstartdate datetime, 
		@listid int, 
		@maxdialercount int,
		@maxperday int

select @callstartdate = '2013-11-01', 
	   @maxdialercount = -1,
	   @maxperday = 1
	   
select @listid = vicimainlistid from tblvicicampaigngroup Where vicicampaignid = 'Settlem'

Select Top (@TopN)
[callorder] = case when m.dialercount = 0 then 1 
				   else 101 end,
[leadid] = m.MatterId,
[phone] = vwp.phone,
[firstname] = p.firstname,
[middlename] = '',
[lastname] = p.lastname,
[address] = p.street, 
[city] = p.city,  
[statecode] = sh.statecode, 
[zipcode] = p.zipcode, 
[dob] = p.dateofbirth, 
[altphone] = vwp1.phone, 
[address3] = vwp2.phone,
[email] = p.emailaddress,
[dialerstatusid] = m.dialerstatusid, 
[outcallerid] = NULL, 
[created] = s.lastmodified, 
[vicimainlistid] = @listId,
[clientid] = m.clientid
FROM 
	tblTask t 
	inner join tblMatterTask mt ON mt.TaskId = t.TaskId 
	inner join tblMatter m ON m.MatterId = mt.MatterId  
	inner join tblSettlements s ON s.MatterId = m.MatterId
	inner join tblClient c ON c.ClientId = m.ClientId  
	inner join vw_Vici_Client_Phones vwp on c.clientid = vwp.clientid and vwp.ranked = 1
	inner join tblPerson p ON p.clientId = c.clientId and p.relationship = 'prime'
	inner join vw_states_hours sh with (nolock) on p.stateid = sh.stateid and (getdate() between sh.startdate and sh.enddate)
	inner join tbldialerstatus d on d.dialerstatusid = m.dialerstatusid and d.usedialer = 1
	left join vw_Vici_Client_Phones vwp1 on c.clientid = vwp1.clientid and vwp1.ranked = 2
	left join vw_Vici_Client_Phones vwp2 on c.clientid = vwp2.clientid and vwp2.ranked = 3
	left join tblViciMatterCallSummary mdc on mdc.matterid = m.matterid and mdc.calldate = cast(convert(varchar(10), Getdate(), 120)  as datetime)
WHERE 
	t.TaskTypeId in (72, 78) --Pendig Client Approval
	and (t.TaskResolutionId is null or t.TaskResolutionId not in (1,2,3,4))
	and (s.Active = 1 and GetDate() < DateAdd(d,1,s.SettlementDueDate))
	and m.IsDeleted = 0 and m.MatterStatusId not in (2,4) and m.mattertypeid = 3
	and c.currentclientstatusid not in (15,16,17,18)
	and (c.dialerResumeAfter is null or c.DialerResumeAfter < getdate())
	and (m.dialerRetryAfter is null or m.DialerRetryAfter < getdate())
	and s.lastmodified > @callstartdate
	and	(mdc.DayCallCount is null or ( mdc.DayCallCount < @maxperday))
Order By 1, s.LastModified desc

END

GO



 

