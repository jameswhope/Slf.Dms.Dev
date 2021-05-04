if exists (select 1 from sysobjects where name = 'vw_ClientDeposits')
	drop view vw_ClientDeposits
go

create view vw_ClientDeposits
as


select c.clientid, count(distinct r.registerid) [deposits]
from tblclient c
left join tblregister r on r.clientid = c.clientid
	and r.entrytypeid = 3 -- Deposit
	and r.bounce is null
	and r.void is null
group by c.clientid 

