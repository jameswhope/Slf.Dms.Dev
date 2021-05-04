
if object_id('tblLeadVendors') is null begin
	create table tblLeadVendors
	(
		VendorID int identity(200,1) not null,
		VendorCode varchar(50) not null,
		CategoryID int not null,
		DefaultCost money default(0) not null,
		SuppressionEmail varchar(300),
		LastModified datetime,
		LastModifiedBy int,
		Password varchar(15),
		LastLogin datetime,
		NumLogins int default(0) not null,
		Active bit default(1) not null,
		primary key (VendorID),
		foreign key (CategoryID) references tblLeadCategories(CategoryID) on delete cascade
	)
end

--if not exists (select 1 from tblLeadVendors where vendorcode in ('RGR','HYDRA','WISDOM')) begin
--	insert tblLeadVendors (VendorCode,CategoryID) values ('RGR',100)
--	insert tblLeadVendors (VendorCode,CategoryID) values ('HYDRA',101)
--	insert tblLeadVendors (VendorCode,CategoryID) values ('WISDOM',100) 
--end