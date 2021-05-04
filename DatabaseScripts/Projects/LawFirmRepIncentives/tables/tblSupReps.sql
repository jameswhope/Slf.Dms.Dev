
if object_id('tblSupReps') is null begin
	CREATE TABLE tblSupReps
	(
		UserID int not null,
		DateCreated datetime default(getdate()),
		foreign key (UserID) references tblUser(UserID) on delete cascade
	) 
end 