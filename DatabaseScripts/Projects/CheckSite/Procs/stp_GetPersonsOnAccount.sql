if exists (select * from sysobjects where name = 'stp_GetPersonsOnAccount')
	drop procedure stp_GetPersonsOnAccount
go

create procedure stp_GetPersonsOnAccount
(
	@ClientID int
)
as
begin
/*
	History:
	jhernandez		05/23/08	Returns person accounts related to a client
	jhernandez		09/03/08	Address info
*/

select p.FirstName, p.LastName, isnull(p.SSN,'') [SSN], c.AccountNumber,
	isnull(Street,'') [Address1], isnull(Street2,'') [Address2], isnull(City,'') [City],
	isnull(s.Abbreviation,'') [State], isnull(ZipCode,'') [ZipCode],
	case when p.PersonID = c.PrimaryPersonID then 1 else 0 end [IsPrimary]
from tblPerson p
join tblClient c on c.ClientID = p.ClientID
left join tblState s on s.StateID = p.StateID
where p.ClientID = @ClientID
order by [IsPrimary] desc


end