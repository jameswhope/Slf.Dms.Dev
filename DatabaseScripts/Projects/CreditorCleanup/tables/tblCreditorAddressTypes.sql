
create table tblCreditorAddressTypes
(
	CreditorAddressTypeID int identity(100,1) not null,
	AddressType varchar(100) not null,
	Created datetime default(getdate()) not null,
	CreatedBy int not null,
	
	primary key (CreditorAddressTypeID)
)

insert tblCreditorAddressTypes (AddressType,CreatedBy) values ('Payment',820)
insert tblCreditorAddressTypes (AddressType,CreatedBy) values ('Express Payments',820)
insert tblCreditorAddressTypes (AddressType,CreatedBy) values ('Inquires/Correspondences/Questions/Customer Service',820)
insert tblCreditorAddressTypes (AddressType,CreatedBy) values ('Bankruptcy',820)
insert tblCreditorAddressTypes (AddressType,CreatedBy) values ('Billing Errors',820)
insert tblCreditorAddressTypes (AddressType,CreatedBy) values ('Unspecified',820)



