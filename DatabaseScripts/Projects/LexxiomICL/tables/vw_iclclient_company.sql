create view vw_iclclient_company
AS
select c.clientid, 
c.companyid, 
case when c.trustid = 26 then 8 else companyid end lexxcompanyid, 
c.trustid 
from tblclient c