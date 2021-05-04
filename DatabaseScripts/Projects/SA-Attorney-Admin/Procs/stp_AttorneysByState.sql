if exists (select * from sysobjects where name = 'stp_AttorneysByState')
	drop procedure stp_AttorneysByState
go

create procedure stp_AttorneysByState
(
	@State char(2)
,	@CompanyID int
)
as
begin
/*
	History:
	jhernandez		12/06/07		Used for setting state primaries. Note, 
									attorneys are assigned to states independently from their associations
									to a company. When setting a state primary for a company, the attorney
									must already be associated with that company through a relation.
*/

select 
	a.AttorneyID
,	a.LastName + ', ' + a.FirstName + ' ' + isnull(a.MiddleName,'') [Name]
from 
	tblAttyStates s 
join tblAttorney a
	on s.AttorneyID = a.AttorneyID
join tblAttyRelation r
	on r.AttorneyID = a.AttorneyID
	 and r.CompanyID = @CompanyID
where
	s.State = @State
order by
	a.LastName, a.FirstName, a.MiddleName


end