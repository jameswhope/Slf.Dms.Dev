if exists (select * from sysobjects where name = 'stp_AttorneyDetail')
	drop procedure stp_AttorneyDetail
go

create procedure stp_AttorneyDetail
(
	@AttorneyID int
)
as
begin
/*
	History:
	jhernandez		12/07/07		
*/

select 
	AttorneyID
,	a.FirstName
,	a.LastName
,	isnull(MiddleName,'') [MiddleName]
,	isnull(Suffix,'') [Suffix]
,	isnull(Address1,'') [Address1]
,	isnull(Address2,'') [Address2]
,	isnull(City,'') [City]
,	isnull(State,'') [State]
,	isnull(Zip,'') [Zip]
,	isnull(Phone1,'') [Phone1]
,	isnull(Phone2,'') [Phone2]
,	isnull(Fax,'') [Fax]
,	isnull(a.UserID,-1) [UserID]
,	isnull(u.Username,'') [Username]
from 
	tblAttorney a
left join
	tblUser u on u.UserID = a.UserID
where 
	AttorneyID = @AttorneyID


select 
	s.Name
,	s.Abbreviation [State]
,	isnull(a.StateBarNum,'') [StateBarNum]
,	case when AttorneyID is not null then 'true' else 'false' end [IsRelated]
from
	tblState s
left join tblAttyStates a
	on a.State = s.Abbreviation
	 and a.AttorneyID = @AttorneyID
order by
	s.Name


select 
	c.CompanyID
,	c.ShortCoName
,	isnull(r.AttyRelation,'') [Relation]
,	case when r.AttorneyID is not null then 'true' else 'false' end [IsRelated]
from 
	tblCompany c
left join tblAttyRelation r
	on r.CompanyID = c.CompanyID
	 and r.AttorneyID = @AttorneyID
order by
	c.ShortCoName


end