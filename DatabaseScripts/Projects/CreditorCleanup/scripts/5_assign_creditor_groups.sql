
-- assign non-validated creditors to existing creditor groups where we can 
update tblcreditor
set creditorgroupid = g.creditorgroupid, lastmodified = getdate(), lastmodifiedby = 820
from tblcreditor c
join tblcreditorgroup g on g.name = c.name
where c.validated is null
and c.creditorgroupid is null
and c.creditorid in (
	-- only update unique creditors
	select min(creditorid)
	from tblcreditor c
	join tblcreditorgroup g on g.name = c.name
	where c.validated is null
	and c.creditorgroupid is null
	and c.street is not null
	and c.street <> ''
	and c.street <> 'need'
	and c.city <> ''
	group by c.name, c.street, isnull(c.street2,''), c.city, c.stateid, left(c.zipcode,5)
)


select distinct name
into #names
from tblcreditor
where validated is null
and creditorgroupid is null
and name not in (select name from tblcreditorgroup)

-- add new creditor group names (~36k)
insert tblcreditorgroup (name,created,createdby,lastmodified,lastmodifiedby)
select distinct name, getdate(), 820, getdate(), 820
from tblcreditor
where validated is null
and creditorgroupid is null
and name not in (select name from tblcreditorgroup)

-- assign non-validated creditors to new creditor groups 
update tblcreditor
set creditorgroupid = g.creditorgroupid, lastmodified = getdate(), lastmodifiedby = 820
from tblcreditor c
join tblcreditorgroup g on g.name = c.name
where c.validated is null
and c.creditorgroupid is null
and c.creditorid in (
	-- only update unique creditors
	select min(creditorid)
	from tblcreditor c
	join tblcreditorgroup g on g.name = c.name
	where c.validated is null
	and c.creditorgroupid is null
	and c.street is not null
	and c.street <> ''
	and c.street <> 'need'
	and c.city <> ''
	group by c.name, c.street, isnull(c.street2,''), c.city, c.stateid, left(c.zipcode,5)
)
and g.name in (
	-- only newly inserted names
	select name from #names
)

-- should be 0!
--select name
--from tblcreditorgroup
--group by name
--having count(*) > 1

-- the remaining creditors with null creditorgroupids are dups and do not need to be assigned
-- the cleanup tool should be used to consolidate these
/*
-- all groups should be assigned to at least 1 creditor
select creditorgroupid, count(*) [cnt]
from tblcreditor
where creditorgroupid is not null
group by creditorgroupid
order by cnt 
*/