
/*
	History:
	11/29/07	jhernandez	Created.
*/
if object_id('tblCommRecPhone') is null begin
	create table tblCommRecPhone
	(
		CommRecPhoneID int identity(1,1) not null
	,	CommRecID int not null
		foreign key (CommRecID) references tblCommRec(CommRecID) on delete cascade
	,	PhoneNumber varchar(15) not null
	,	Created datetime not null default(getdate())
	,	CreatedBy int not null
	,	LastModified datetime
	,	LastModifiedBy int
	)
end 