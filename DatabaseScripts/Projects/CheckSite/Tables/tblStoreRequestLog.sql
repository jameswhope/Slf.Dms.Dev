
if object_id('tblStoreRequestLog') is null begin
	create table tblStoreRequestLog
	(
		RequestLogId int identity(1,1) not null
	,	ClientID int not null
	,	RequestType varchar(20) not null
	,	StatusDesc varchar(2000) not null
	,	Notes varchar(8000)
	,	RequestedDate datetime default(getdate()) not null
	,	RequestedBy int
	,	foreign key (ClientID) references tblClient(ClientID) on delete cascade
	)
end