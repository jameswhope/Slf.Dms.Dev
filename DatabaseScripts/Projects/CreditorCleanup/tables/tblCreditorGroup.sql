
create table tblCreditorGroup
(
	CreditorGroupID int identity(1,1) not null,
	Name varchar(250) not null,
	Created datetime default(getdate()) not null,
	CreatedBy int not null,
	LastModified datetime,
	LastModifiedBy int,
	primary key (CreditorGroupID)
) 