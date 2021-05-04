
-- deleteing orphan creditors
delete
from tblCreditor
where creditorid not in (
	select distinct creditorid
	from tblcreditorinstance
	union
	select distinct forcreditorid
	from tblcreditorinstance
	where forcreditorid is not null
	union
	select distinct creditorid
	from tblcontact
	union
	select distinct creditorid
	from tblcreditorphone
)
and validated is null
and creditorgroupid is null 