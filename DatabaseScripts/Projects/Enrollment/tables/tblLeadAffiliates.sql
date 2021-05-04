
create table tblLeadAffiliates
(
	AffiliateID int identity(1,1) not null,
	AffiliateCode varchar(20) not null, -- Vendors will provide
	AffiliateDesc varchar(200) not null,
	ProductID int not null,
	Created datetime default(getdate()) not null,
	CreatedBy int,
	LastModified datetime,
	LastModifiedBy int,
	primary key (AffiliateID),
	foreign key (ProductID) references tblLeadProducts(ProductID) on delete cascade
) 