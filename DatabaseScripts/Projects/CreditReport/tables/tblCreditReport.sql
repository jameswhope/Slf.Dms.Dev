
create table tblCreditReport
(
	ReportID int identity(1,1) not null,
	CreditReportId varchar(30) not null,
	RequestDate datetime default(getdate()) not null,
	RequestBy int not null,
	primary key (ReportID)
)