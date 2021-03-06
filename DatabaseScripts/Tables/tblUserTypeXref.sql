
if object_id('tblUserTypeXref') is null begin
	create table tblUserTypeXref
	(
		UserTypeId int not null
	,	UserGroupId int not null
	,	foreign key (UserTypeId) references tblUserType(UserTypeId) on delete cascade
	,	foreign key (UserGroupId) references tblUserGroup(UserGroupId) on delete cascade
	)

	insert tblUserTypeXref
	select distinct usertypeid, usergroupid
	from tbluser
	where usergroupid is not null
	order by usertypeid, usergroupid
end