
if object_id('tr_i_tblAgency','TR') is not null
	drop trigger tr_i_tblAgency
go

create trigger tr_i_tblAgency on tblAgency after insert
as
begin

declare @AgencyID int
select @AgencyID = AgencyID from INSERTED 

insert tblUserAgencyAccess (UserID, AgencyID)
select UserID, @AgencyID
from tblUser 
where AgencyID = -99 --ALL

end
go   