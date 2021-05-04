
-- flag expired settlement alerts
update tblclientalerts
set deleted = 1
from tblclientalerts a
join tblsettlements s on s.settlementid = a.alertrelationid
and s.settlementduedate < dateadd(day,-1,getdate())
where a.deleted = 0
and a.resolved is null
and a.alertrelationtype = 'tblSettlements' 
and a.alertdescription like 'Waiting for Client Approval%'