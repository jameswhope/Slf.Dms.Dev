
/*
	Moves agency id to user table allowing multiple users per agency
*/

if not exists (select 1 from syscolumns where id = object_id('tblUser') and name = 'AgencyID')  begin

	alter table tblUser add AgencyID int default(-1)

	update tblUser 
	set AgencyID = isnull(a.AgencyID,-1)
	from tblUser u
	left join tblAgency a on a.UserID = u.UserID
	where u.AgencyID is null

	declare @AgencyID int

	select @AgencyID = AgencyID 
	from tblUser 
	where UserName = 'debtchoice'

	update tblUser
	set AgencyID = @AgencyID
	where UserName = 'debtchoice08'

end