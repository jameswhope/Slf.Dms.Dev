
if object_id('tblCreditEmployer') is null begin
	create table tblCreditEmployer
	(
		CreditEmployerID int identity(1,1) not null,
		CreditSourceID int not null,
		Employer varchar(200),
		StreetAddress varchar(300),
		SelfEmployed char(1),
		EmploymentReportedDate datetime,
		Created datetime default(getdate()) not null,
		primary key (CreditEmployerID),
		foreign key (CreditSourceID) references tblCreditSource(CreditSourceID) on delete cascade
	) 
end