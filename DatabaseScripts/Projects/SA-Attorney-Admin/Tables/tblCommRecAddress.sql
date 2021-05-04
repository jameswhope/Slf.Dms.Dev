
/*
	History:
	11/29/07	jhernandez	Created.
*/
if object_id('tblCommRecAddress') is null begin
	create table tblCommRecAddress
	(
		CommRecAddressID int identity(1,1) not null
	,	CommRecID int not null
		foreign key (CommRecID) references tblCommRec(CommRecID) on delete cascade
	,	Contact1 varchar(75)
	,	Contact2 varchar(75)
	,	Address1 varchar(150) not null
	,	Address2 varchar(150)
	,	City varchar(75)
	,	State char(2)
	,	Zipcode varchar(15)
	,	Created datetime not null default(getdate())
	,	CreatedBy int not null
	,	LastModified datetime
	,	LastModifiedBy int
	)
end 