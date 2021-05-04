
if object_id('tblLeadPhoneList') is null begin
	create table tblLeadPhoneList
	(
		LeadPhoneListID int identity(1,1) not null,
		ForDate datetime not null,
		LeadSourceID int not null,
		Phone varchar(10),
		Budget money,
		Actual money,
		Created datetime default(getdate()) not null,
		CreatedBy int not null,
		LastModified datetime default(getdate()) not null,
		LastModifiedBy int not null,
		Deleted bit default(0) not null,
		primary key (LeadPhoneListID),
		foreign key (LeadSourceID) references tblLeadSource(LeadSourceID) on delete no action
	)
end
go

insert tblLeadPhoneList (ForDate,LeadSourceID,Phone,Budget,Actual,CreatedBy,LastModifiedBy)
values ('4/13/09',1,'8005551234',1000,1200,820,820)
go