if exists (select * from sysobjects where name = 'stp_AttorneyStateLic')
	drop procedure stp_AttorneyStateLic
go

create procedure stp_AttorneyStateLic
(
	@AttorneyID int
,	@CompanyID int = -1
)
as
begin
/*
	History:
	jhernandez		12/10/07		Created. Passing in CompanyID will return which of the 
									licensed state(s) the attorney is the primary for.
*/

select 
	s.AttyStateID
,	s.State
,	s.StateBarNum
,	case when p.State is not null then 'true' else 'false' end [IsPrimary]
from 
	tblAttyStates s
left join tblCompanyStatePrimary p
	on p.AttorneyID = s.AttorneyID
	 and p.State = s.State
	 and p.CompanyID = @CompanyID
where 
	s.AttorneyID = @AttorneyID
order by
	s.State

end