if exists (select 1 from sys.objects where name = 'vw_CIDFirstDeposits') begin
	drop view vw_CIDFirstDeposits
end
go

create view [dbo].[vw_CIDFirstDeposits]
as
-- Used to check if clients have a first deposit in the system
/*
select clientid, min(depositdate) [firstdeposit]
from (
	-- adhoc initial draft setup 
	select a.clientid, a.depositdate
	from tblclient c
	join tbladhocach a on a.clientid = c.clientid
	where c.agencyid = 856 -- client intake
	and a.initialdraftyn = 1

	union*/

	-- first good deposit received
	select r.clientid, min(r.transactiondate) [firstdeposit]
	from tblclient c
	join tblregister r on r.clientid = c.clientid
	where c.agencyid = 856 -- client intake
	and r.entrytypeid = 3 -- deposit
	and r.bounce is null
	group by r.clientid

	/*union

	-- by deposit start date, needs to have an ACH deposit setup
	select c.clientid, c.depositstartdate
	from tblclient c
	join tblclientdepositday d on d.clientid = c.clientid
	where c.agencyid = 856 -- client intake
	and d.depositmethod = 'ACH'
) d
group by clientid */