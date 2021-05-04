IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SaveUserAgencyAccess')
	BEGIN
		DROP  Procedure  stp_SaveUserAgencyAccess
	END
GO

create procedure stp_SaveUserAgencyAccess
(
	@UserID int,
	@AgencyIDs varchar(1000)
)
as
begin

if @AgencyIDs = '-99' begin
	select @AgencyIDs = coalesce(@AgencyIDs + ',', '') + cast(AgencyID as varchar(4))
	from tblAgency
end

insert 
	tblUserAgencyAccess (UserID, AgencyID)
select 
	UserID, AgencyID
from 
(
	select @UserID as UserID, a.AgencyID
	from dbo.splitstr(@AgencyIDs,',') s
	join tblAgency a on a.AgencyID = s.Value
) dev
where not exists (select 1 from tblUserAgencyAccess u where u.UserID = dev.UserID and u.AgencyID = dev.AgencyID)


delete from tblUserAgencyAccess
where UserID = @UserID
and AgencyID not in (select [value] from dbo.splitstr(@AgencyIDs,','))


end
go 