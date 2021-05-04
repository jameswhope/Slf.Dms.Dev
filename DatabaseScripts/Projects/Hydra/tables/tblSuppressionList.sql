
create table tblSuppressionList
(
	SuppressionListID int identity(1,1) not null,
	DateSent datetime default(getdate()) not null,
	primary key (SuppressionListID)
) 