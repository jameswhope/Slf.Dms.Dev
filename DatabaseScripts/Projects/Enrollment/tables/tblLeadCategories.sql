
create table tblLeadCategories
(
	CategoryID int identity(100,1) not null,
	Category varchar(50) not null,
	primary key (CategoryID)
)

insert tblLeadCategories (Category) values ('3rd Party Internet')
insert tblLeadCategories (Category) values ('Self-generated Internet')
insert tblLeadCategories (Category) values ('Radio')
insert tblLeadCategories (Category) values ('TV') 