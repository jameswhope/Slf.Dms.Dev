 IF col_length('tblUserGroup', 'SeaarchOnPickup') is null
	Alter table tblUserGroup Add SearchOnPickup bit not null default 1 
  GO	