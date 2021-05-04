
create table tblLeadStatusGroup
(
	StatusGroupID int identity(100,1) not null,
	GroupName varchar(30) not null,
	primary key (StatusGroupID)
)

insert tblLeadStatusGroup (GroupName) values ('Success')
insert tblLeadStatusGroup (GroupName) values ('Failures')
insert tblLeadStatusGroup (GroupName) values ('No Contact')
insert tblLeadStatusGroup (GroupName) values ('Bad Leads')
insert tblLeadStatusGroup (GroupName) values ('Pipeline')
insert tblLeadStatusGroup (GroupName) values ('New')
insert tblLeadStatusGroup (GroupName) values ('Recycled')
 