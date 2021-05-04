if exists (select * from sysobjects where name = 'stp_UserAgency')
	drop procedure stp_UserAgency
go

create procedure stp_UserAgency
(
	@UserID int
)
as
begin


if exists (select 1 from tblUser where UserID = @UserID and AgencyID = -99) begin
	select -99, 'ALL', 'ALL'
end
else if exists (select 1 from tblUserAgencyAccess where UserID = @UserID) begin
	select a.AgencyID, a.Code, a.Name
	from tblUserAgencyAccess u
	join tblAgency a on a.AgencyID = u.AgencyID
	where u.UserID = @UserID
	order by a.Name
end
else begin
	select '-1', 'None', 'None'
end


end 