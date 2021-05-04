 
create table tblInvalidZipCodes
(
	Zipcode varchar(20) not null,
	PublisherId varchar(50) not null,
	UserHostAddress varchar(20) not null,
	Created datetime default(getdate()) not null
)