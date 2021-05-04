if exists (select * from sysobjects where name = 'stp_UserCompanies')
	drop procedure stp_UserCompanies
go

create procedure stp_UserCompanies
(
	@UserID int
)
as
begin

declare @CompanyIDs varchar(500)

select @CompanyIDs = CompanyIDs from tblUserCompany where UserID = @UserID

if len(@CompanyIDs) > 0 begin
	exec('
	declare @list varchar(1000)

	select @list = coalesce(@list + '', '', '''') + cast(ShortCoName AS varchar(50))
	from tblCompany
	where CompanyID in (' + @CompanyIDs + ')

	select ''' + @CompanyIDs + ''', case when len(@list) > 30 then left(@list,30) + ''..'' else @list end
	')
end
else begin
	select '-1', 'None'
end


end