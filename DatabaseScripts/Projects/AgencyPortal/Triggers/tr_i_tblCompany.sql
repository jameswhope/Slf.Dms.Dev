
if object_id('tr_i_tblCompany','TR') is not null
	drop trigger tr_i_tblCompany
go

create trigger tr_i_tblCompany on tblCompany after insert
as
begin

declare @CompanyID int
select @CompanyID = CompanyID from INSERTED 

insert tblUserCompanyAccess (UserID, CompanyID)
select UserID, @CompanyID
from tblUser 
where CompanyID = -99 --ALL

end
go 