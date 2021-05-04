if exists (select * from sysobjects where name = 'stp_InsertCompanyPhone')
	drop procedure stp_InsertCompanyPhone
go 

create procedure stp_InsertCompanyPhone
(
  @CompanyID int
, @PhoneType int
, @PhoneNumber varchar(15)
)
as
begin

declare @CompanyPhoneID int

select @CompanyPhoneID = max(CompanyPhoneID) + 1
from tblCompanyPhones

insert into tblCompanyPhones (CompanyPhoneID,CompanyID,PhoneType,PhoneNumber)
values (@CompanyPhoneID,@CompanyID,@PhoneType,@PhoneNumber)

end
go  