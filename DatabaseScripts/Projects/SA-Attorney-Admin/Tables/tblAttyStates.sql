
if object_id('tblAttyStates') is null begin
	
	create table tblAttyStates
	(
		AttyStateID int identity(1,1) not null
	,	AttorneyID int not null foreign key (AttorneyID) references tblAttorney(AttorneyID) on delete cascade
	,	State char(3) not null primary key (AttorneyID,State)
	,	StateBarNum varchar(30) null
	,	Created datetime default(getdate())
	)

end



