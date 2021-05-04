
create view vw_NonDepositClients
as

select distinct n.clientid
from tblnondeposit n
join tblmatter m on m.matterid = n.matterid
	and m.matterstatusid in (1,3) -- Open, Pending
where n.deleted is null 