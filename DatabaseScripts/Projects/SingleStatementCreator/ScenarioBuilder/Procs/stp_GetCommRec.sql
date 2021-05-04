if exists (select * from sysobjects where name = 'stp_GetCommRec')
	drop procedure stp_GetCommRec
go

create procedure stp_GetCommRec
(
	@CompanyID int
,	@AccountTypeID int
)
as
begin

select 
	*
from 
	tblCommRec
where
	CompanyID = @CompanyID
	and AccountTypeID = @AccountTypeID

end