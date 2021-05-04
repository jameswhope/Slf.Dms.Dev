
if object_id('tblIncentiveDetail') is null begin
	create table tblIncentiveDetail
	(
		IncentiveDetailID int identity(1,1) not null,
		IncentiveID int not null,
		ClientID int not null,
		RegisterID int null,
		IsInitial bit not null,
		Eligible bit default(1) not null,
		primary key (IncentiveDetailID),
		foreign key (IncentiveID) references tblIncentives(IncentiveID) on delete cascade,
		foreign key (ClientID) references tblClient(ClientID) on delete no action
	)
end
else begin
	-- RegisterID only required for residuals
	alter table tblincentivedetail drop FK__tblIncent__Regis__27BC24D2
end


-- alter table tblincentivedetail add Eligible bit default(1) not null
