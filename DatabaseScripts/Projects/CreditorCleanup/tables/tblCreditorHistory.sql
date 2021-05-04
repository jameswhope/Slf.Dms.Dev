
create table tblCreditorHistory
(
	CreditorHistoryID int identity(1,1) not null,
	CreditorID int not null,
	NewCreditorID int null,
	Name varchar(250),
	Street varchar(50),
	Street2 varchar(50),
	City varchar(50),
	StateID int,
	ZipCode varchar(50),
	Validated bit default(0) not null,
	Approved bit default(0) not null,
	Duplicate bit default(0) not null,
	Created datetime default(getdate()) not null,
	CreatedBy int,
	LastModified datetime,
	LastModifiedBy int,
	Primary key (CreditorHistoryID)
)