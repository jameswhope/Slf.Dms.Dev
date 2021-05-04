
CREATE TABLE tblHydraReps
(
	UserID int not null,
	LastLeadAssignedTo datetime,
	foreign key (UserID) references tblUser(UserID) on delete cascade
) 
