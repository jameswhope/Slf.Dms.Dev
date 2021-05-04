
alter table tblCreditor add CreditorGroupID int 
go
alter table tblCreditor add foreign key (CreditorGroupID) references tblCreditorGroup(CreditorGroupID) on delete cascade
go
alter table tblCreditor add CreditorAddressTypeID int
go
alter table tblCreditor add foreign key (CreditorAddressTypeID) references tblCreditorAddressTypes(CreditorAddressTypeID) on delete no action
go
update tblCreditor set CreditorAddressTypeID = 105 where 1=1 -- Unspecified
go