
create table tblPageHits
(
	PageHitID int identity(1,1) not null,
	Host varchar(100),
	Page varchar(500) not null,
	IPAddress varchar(15) not null,
	Browser varchar(200),
	Date datetime default(getdate())
) 