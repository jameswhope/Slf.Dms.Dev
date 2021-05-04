
-- rev share costs
update tblleadproducts set cost = 80 where productid in (142,145,146)
update tblleadproducts set cost = 200 where productid in (147)


update tblleadapplicant
set cost = 80
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join vw_enrollment_Ver_complete e on e.leadapplicantid = l.leadapplicantid
where l.productid = 142
and l.created > '10/1/10'
and e.completed is not null
and l.cost = 0 