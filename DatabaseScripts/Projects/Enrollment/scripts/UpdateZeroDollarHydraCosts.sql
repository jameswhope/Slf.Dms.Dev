
-- ran 3/10/2010

update tblleadapplicant 
set cost = 20
from tblleadapplicant l
join tblleadproducts p on p.productid = l.productid
where l.productid > 0
and l.cost = 0
and p.cost = 0
and p.vendorid = 201 -- Hydra
and p.productcode like '10%'

update tblleadproducts
set cost = 20, lastmodified = getdate(), lastmodifiedby = 820
where cost = 0
and vendorid = 201 -- Hydra
and productcode like '10%' 