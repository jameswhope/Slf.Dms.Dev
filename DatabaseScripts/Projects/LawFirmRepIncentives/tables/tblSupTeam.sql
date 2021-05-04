
if object_id('tblSupTeam') is null begin
	create table tblSupTeam
	(
		SupID int not null,
		RepID int not null
	)
end 