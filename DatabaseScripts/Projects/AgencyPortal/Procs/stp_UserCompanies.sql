if exists (select * from sysobjects where name = 'stp_UserCompanies')
	drop procedure stp_UserCompanies
go

create procedure stp_UserCompanies
(
	@UserID int
)
as
begin


if exists (select 1 from tblUser where UserID = @UserID and CompanyID = -99) begin
	select -99, 'ALL', 'ALL'
end
else if exists (select 1 from tblUserCompanyAccess where UserID = @UserID) begin
	select c.CompanyID, c.ShortCoName [Company]
	from tblUserCompanyAccess u
	join tblCompany c on c.CompanyID = u.CompanyID
	where u.UserID = @UserID
	order by c.CompanyID
end
else begin
	select '-1', 'None', 'None'
end


end
go