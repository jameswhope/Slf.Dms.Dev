
if object_id('tblClientEmailErrorLog') is null begin 
	create table tblClientEmailErrorLog
	(
		ErrorLogID int identity(1,1) not null,
		ClientID int not null,
		Exception varchar(max) not null,
		Type varchar(30) not null,
		ExceptionDate datetime default(getdate()) not null,
		foreign key (ClientID) references tblClient(ClientID) on delete cascade
	)
end