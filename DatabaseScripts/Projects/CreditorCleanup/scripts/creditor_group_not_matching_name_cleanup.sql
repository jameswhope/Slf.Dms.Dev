
select g.name, c.name, c.creditorid
from tblcreditor c 
join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid
where g.name <> c.name
order by c.name

update tblcreditor
set name = g.name
from tblcreditor c
join tblcreditorgroup g on g.creditorgroupid = c.creditorgroupid
where c.name <> g.name 