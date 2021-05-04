
if object_id('tblLeadMarket') is null begin
	create table tblLeadMarket
	(
		LeadMarketID int identity(100,1) not null,
		Market varchar(100) not null,
		Created datetime default(getdate()) not null,
		CreatedBy int not null,
		LastModified datetime null,
		LastModifiedBy int null,
		primary key (LeadMarketID)
	)
end
go

--insert tblLeadMarket (market) values ('Denver-Boulder