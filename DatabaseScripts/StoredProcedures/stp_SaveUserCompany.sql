if exists (select * from sysobjects where name = 'stp_SaveUserCompany')
	drop procedure stp_SaveUserCompany
go

create procedure stp_SaveUserCompany
(
	@UserID int
,	@CompanyIDs varchar(50)
)
as
begin


if @CompanyIDs = '-1' begin
	delete from tblUserCompany where UserID = @UserID
end
else if not exists (select 1 from tblUserCompany where UserID = @UserID) begin
	insert tblUserCompany values (@UserID, @CompanyIDs)
end
else begin
	update tblUserCompany set CompanyIDs = @CompanyIDs where UserID = @UserID
end


end