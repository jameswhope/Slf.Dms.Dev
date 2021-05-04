
CREATE TABLE tblRGRReps
(
	UserID int not null,
	LastLeadAssignedTo datetime,
	foreign key (UserID) references tblUser(UserID) on delete cascade
)  