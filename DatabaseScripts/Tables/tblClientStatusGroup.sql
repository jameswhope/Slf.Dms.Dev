
create table tblClientStatusGroup
(
	ClientStatusGroupID int identity(100,1) not null,
	Name varchar(30) not null
)

create table tblClientStatusXref
(
	ClientStatusGroupID int not null,
	ClientStatusID int not null
)

insert tblClientStatusGroup values ('All')
insert tblClientStatusGroup values ('Active')
insert tblClientStatusGroup values ('Cancelled')
insert tblClientStatusGroup values ('Completed')
insert tblClientStatusGroup values ('Non-Responsive')

insert tblClientStatusXref select 100,clientstatusid from tblclientstatus 
insert tblClientStatusXref select 101,clientstatusid from tblclientstatus where clientstatusid not in (15,16,17,18)
insert tblClientStatusXref select 102,17
insert tblClientStatusXref select 103,18
insert tblClientStatusXref select 104,16 