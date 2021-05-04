
if object_id('tblAttorneyType') is null
 begin
	create table tblAttorneyType
	(
		AttorneyTypeID int not null
	,	[Type] varchar(20) not null
	,	Employed bit not null
	)

	--insert tblAttorneyType values (1, 'Local Counsel',0) -- formerly Associated
	--insert tblAttorneyType values (2, 'Associate',1) -- formerly Of Counsel
	--insert tblAttorneyType values (3, 'Principle',1) -- formerly Primary
 end