IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SaveUserCompanyAccess')
	BEGIN
		DROP  Procedure  stp_SaveUserCompanyAccess
	END
GO

create procedure stp_SaveUserCompanyAccess
(
	@UserID int,
	@CompanyIDs varchar(1000)
)
as
begin

if @CompanyIDs = '-99' begin
	select @CompanyIDs = coalesce(@CompanyIDs + ',', '') + cast(CompanyID as varchar(4))
	from tblCompany
end

insert 
	tblUserCompanyAccess (UserID, CompanyID)
select 
	UserID, CompanyID
from 
(
	select @UserID as UserID, c.CompanyID
	from dbo.splitstr(@CompanyIDs,',') s
	join tblCompany c on c.CompanyID = s.Value
) dev
where not exists (select 1 from tblUserCompanyAccess u where u.UserID = dev.UserID and u.CompanyID = dev.CompanyID)


delete from tblUserCompanyAccess
where UserID = @UserID
and CompanyID not in (select [value] from dbo.splitstr(@CompanyIDs,','))


end
go  