if exists (select * from sysobjects where name = 'stp_GetAgencyList')
	drop procedure stp_GetAgencyList
go

create procedure stp_GetAgencyList
(
	@CompanyID int = -1
)
as
begin
/*
	11/20/07	jhernandez		Created
	01/23/08	jhernandez		Return a column with the agency's most recent scenario for the 
								given company. Optional
*/

create table #tblScen
(
	AgencyID int,
	CommScenID int
)

insert #tblScen 
(
	AgencyID,
	CommScenID
)
select
	c.AgencyID,
	max(c.CommScenID)
from
	tblCommScen c
	join tblCommStruct s on s.CommScenID = c.CommScenID and s.CompanyID = @CompanyID
group by
	c.AgencyID


select
	a.AgencyID,
	a.Name,
	t.CommScenID
from
	tblAgency a
	left join #tblScen t on t.AgencyID = a.AgencyID
order by 
	a.AgencyID


drop table #tblScen



end
