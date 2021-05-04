
if object_id('tblLeadSource') is null begin
	create table tblLeadSource
	(
		LeadSourceID int identity(1,1) not null,
		LeadMarketID int not null,
		Source varchar(100) not null,
		Created datetime default(getdate()) not null,
		CreatedBy int not null,
		primary key (LeadSourceID),
		foreign key (LeadMarketID) references tblLeadMarket(LeadMarketID) on delete no action
	)
end