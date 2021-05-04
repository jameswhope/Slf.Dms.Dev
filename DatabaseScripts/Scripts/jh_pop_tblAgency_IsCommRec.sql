
-- this proc needs to run after tblAgency.sql

update tblAgency
set IsCommRec = case when r.AgencyID is null then 0 else 1 end
from tblAgency a
left join tblCommRec r on r.AgencyID = a.AgencyID
where IsCommRec is null