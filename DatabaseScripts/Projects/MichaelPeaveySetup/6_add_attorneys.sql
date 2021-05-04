
insert tblattorney (companyid,states,stateid,firstname,lastname,middlename,suffix,created,createdby,lastmodified,lastmodifiedby,stateprimary)
select 5,states,stateid,firstname,lastname,middlename,suffix,getdate(),820,getdate(),820,stateprimary
from (
	select states,stateid,firstname,lastname,middlename,suffix,stateprimary
	from tblattorney
	where companyid = 2
) d
where not exists (select 1 from tblattorney a where a.companyid = 5 and a.stateid = d.stateid
					and a.firstname = d.firstname and a.lastname = d.lastname) 