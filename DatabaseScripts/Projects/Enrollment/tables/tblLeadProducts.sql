
create table tblLeadProducts
(
	ProductID int identity(1,1) not null,
	ParentProductID int null,
	ProductCode varchar(20) not null, -- Vendors will provide
	ProductDesc varchar(200) not null,
	VendorID int not null,
	Cost money default(0) not null,
	Created datetime default(getdate()) not null,
	CreatedBy int,
	LastModified datetime,
	LastModifiedBy int,
	Active bit default(1) not null,
	StartTime varchar(20),
	EndTime varchar(20),
	DefaultSourceId int,
	IsDNIS bit default(0) not null,
	NewCost money,
	EffectiveDate datetime,
	ServiceFee money default(90) not null,
	RevShare bit default(0) not null,
	AfterHoursProductID int null,
	primary key (ProductID),
	foreign key (VendorID) references tblLeadVendors(VendorID) on delete cascade
)

/*
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('RGRUNDER10K','Under 10K Leads',200,1,820)
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('RGRREDSTATE','Red State Leads',200,1,820)
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('RGRNONEXCLNW','Non-Exclusive Nationwide',200,1,820)
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('NA','Not Available',200,1,820)

insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('WISDOMUNDER10K','Under 10K Leads',202,1,820)
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('WISDOMREDSTATE','Red State Leads',202,1,820)
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('WISDOMNONEXCLNW','Non-Exclusive Nationwide',202,1,820)
insert tblleadproducts (productcode,productdesc,vendorid,cost,createdby) values ('NA','Not Available',202,1,820)
*/

/*
alter table tblleadproducts add ServiceFee money null
update tblleadproducts set servicefee = 30 where productid = 142
update tblleadproducts set servicefee = 60 where productid = 143
update tblleadproducts set servicefee = 90 where productid = 144
*/

/*
update tblleadproducts set AfterHoursProductID = 145 where productid = 142
update tblleadproducts set AfterHoursProductID = 146 where productid = 143
update tblleadproducts set AfterHoursProductID = 147 where productid = 144
*/