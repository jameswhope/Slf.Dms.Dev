if exists (select * from sysobjects where name = 'stp_CompanyStatePrimaryList')
	drop procedure stp_CompanyStatePrimaryList
go

create procedure stp_CompanyStatePrimaryList
(
	@CompanyID int
)
as
begin


select 
	s.Name
,	s.Abbreviation [State]
,	isnull(p.AttorneyID, -1) [AttorneyID]
from
	tblState s
left join tblCompanyStatePrimary p
	on p.State = s.Abbreviation
	 and p.CompanyID = @CompanyID
order by
	s.Name


end