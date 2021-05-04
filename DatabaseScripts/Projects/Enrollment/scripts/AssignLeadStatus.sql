
update tblleadapplicant
set statusid = 16 -- New
where created = lastmodified
and (statusid = 0 or statusid is null)
and created > '1/1/2010'
and fullname <> ''
and repid > 0

update tblleadapplicant
set statusid = 17 -- Recycled
where (statusid = 0 or statusid is null) 