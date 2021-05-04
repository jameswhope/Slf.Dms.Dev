
alter procedure stp_GetClientServiceInfo
(
	@ClientID int
)
as
begin

select 
	AcctsToSettle = (select count(a.accountid) from tblaccount a 
		where a.clientid = c.clientid 
		and a.accountstatusid <> 55
		AND a.accountstatusid <> 171 
		and not (a.accountstatusid = 54 
		and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))), 
	TotalDebt = isnull((select sum(a.currentamount) from tblaccount a 
		where a.clientid = c.clientid 
		and a.accountstatusid <> 55 
		AND a.accountstatusid <> 171
		and not (a.accountstatusid = 54 
		and exists(select r.registerid from tblregister r where r.entrytypeid = 4 and r.accountid = a.accountid and r.void is null and r.isfullypaid = 1))),0), 
	c.MonthlyFee [PerAcctFee], 
	c.MaintenanceFeeCap [ServiceFeeCap]
from 
	tblclient c
where 
	c.clientid = @ClientID

end
go 