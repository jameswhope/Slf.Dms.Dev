
-- for some reason this table is not being updated when a creditor is replaced? could be only older stuff
-- update 1/11/10: since running this script, no more orphan creditors have been found

update tblcreditliabilitylookup
set creditorid = h.newcreditorid, creditoridupdated = getdate()
from tblcreditliabilitylookup l
join tblcreditorhistory h on h.creditorid = l.creditorid
	and h.newcreditorid > 0
	and h.creditorid <> h.newcreditorid


update tblcreditliabilitylookup
set creditorid = null, creditoridupdated = null
where creditorid not in (select creditorid from tblcreditor)


update tblleadcreditorinstance
set creditorgroupid = -1, creditorid = -1
where creditorid > 0
and creditorid not in (select creditorid from tblcreditor)


-- counts should match
select count(*) --c.name, l.creditorname
from tblcreditliabilitylookup l
join tblcreditor c on c.creditorid = l.creditorid

select count(*)
from tblcreditliabilitylookup
where creditorid > 0
 