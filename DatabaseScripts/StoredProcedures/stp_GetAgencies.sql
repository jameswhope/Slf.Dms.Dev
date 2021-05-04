if exists (select * from sysobjects where name = 'stp_GetAgencies')
	drop procedure stp_GetAgencies
go

create procedure stp_GetAgencies
as

select a.agencyid, a.code, a.name
from (
	select distinct agencyid from tblcommscen
	union 
	select distinct agencyid from tblclient where agencyid > 0
) d
join tblagency a on a.agencyid = d.agencyid
order by a.name

go