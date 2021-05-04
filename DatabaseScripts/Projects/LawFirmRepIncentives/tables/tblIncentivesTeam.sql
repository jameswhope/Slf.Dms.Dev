
if object_id('tblIncentivesTeam') is null begin
	create table tblIncentivesTeam
	(
		SupID int not null,
		RepIncentiveID int not null,
		foreign key (RepIncentiveID) references tblIncentives(IncentiveID) on delete cascade
	)
end