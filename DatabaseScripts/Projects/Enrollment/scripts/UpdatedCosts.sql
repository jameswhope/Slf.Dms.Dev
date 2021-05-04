
--select * from tblleadproducts where cost = 0
--select * from tblleadapplicant where productid in (7,8)

update tblleadproducts set cost = 5 where productid = 1
update tblleadproducts set cost = 10 where productid = 2
update tblleadproducts set cost = 10 where productid = 4
update tblleadproducts set cost = 16 where productid in (5,6)
update tblleadproducts set cost = 10 where productid = 60
update tblleadproducts set cost = 0 where productid in (54,55)

update tblleadproducts 
set cost = 15
where productcode in ('1026017','1050331','54001','50098','45542')
and cost is null

update tblleadproducts 
set cost = 20
where productcode not in ('1026017','1050331','54001','50098','45542')
and vendorid = 201
and cost is null

update tblleadapplicant
set cost = 20
where productid in (select productid from tblleadproducts where vendorid = 201) -- hydra
and created between '1/1/10' and '1/31/10'

update tblleadapplicant
set cost = 15
where productid in (5,6) -- wisdom/pmg red state, nationwide
and created between '1/1/10' and '1/24/10'
and cost is null

update tblleadapplicant
set cost = 10
where productid = 4 -- Wisdom under 10k
and cost is null

update tblleadapplicant
set cost = 5
where productid = 1 -- Rgr under 10k

update tblleadapplicant
set cost = 5
where productid = 2 -- Rgr red state

update tblleadapplicant
set cost = p.cost
from tblleadapplicant l
join tblleadproducts p on p.productid = l.productid
where l.cost is null 