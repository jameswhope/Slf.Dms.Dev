if exists (select * from sysobjects where name = 'stp_GetCommRecs')
	drop procedure stp_GetCommRecs
go

create procedure stp_GetCommRecs
(
	@CommRecTypeID int = null
,	@AccountTypeID int = null
)
as
begin

select 
	r.CommRecID
,	r.Abbreviation
,	t.CommRecTypeID
,	t.Name [CommRecType]
,	r.AccountTypeID
,	r.Display
from 
	tblCommRec r
	join tblCommRecType t on t.CommRecTypeID = r.CommRecTypeID
where 
	1=1
	and (r.CommRecTypeID = @CommRecTypeID or @CommRecTypeID is null)
	and (r.AccountTypeID = @AccountTypeID or @AccountTypeID is null)
order by 
	t.Name, r.Abbreviation

end