
create procedure stp_VendorLogin 
(
	@username varchar(30),
	@password varchar(15)
)
as
begin

declare @vendorid int

set @vendorid = -1

select @vendorid = vendorid 
from tblleadvendors 
where vendorcode = @username 
and [password] = @password

update tblleadvendors
set lastlogin = getdate(), numlogins = numlogins + 1
where vendorid = @vendorid	

--return
select @vendorid


end
go