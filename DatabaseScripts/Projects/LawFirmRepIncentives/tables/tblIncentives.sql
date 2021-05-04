
create table tblIncentives
(
	IncentiveID int identity(1,1) not null,
	IncentiveMonth int not null,
	IncentiveYear int not null,
	RepID int not null,
	InitialCount int not null,
	InitialPayment money not null,
	InitialTotal money not null,
	ResidualCount int default(0) not null,
	ResidualPayment money default(0) not null,
	ResidualTotal money default(0) not null,
	Created datetime default(getdate()) not null,
	TeamCount int default(0) not null,
	TeamPayment money default(0) not null,
	TeamTotal money default(0) not null,
	Adjustment money,
	primary key (IncentiveID),
	foreign key (RepID) references tblUser(UserID) on delete no action
)