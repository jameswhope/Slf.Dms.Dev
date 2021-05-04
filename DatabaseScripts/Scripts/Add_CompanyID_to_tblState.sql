
alter table tblState add CompanyID int null

update tblstate 
set companyid = v.companyid
from tblstate s
join tbllsa_variablestatedata v on v.stateid = s.stateid 