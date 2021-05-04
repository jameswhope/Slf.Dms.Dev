
if object_id('tblCreditLiability') is null begin
	create table tblCreditLiability
	(
		CreditLiabilityID int identity(1,1) not null,
		ReportID int not null,
		CreditSourceID int,
		AccountNumber varchar(30),
		CreditorName varchar(50) not null,
		Street varchar(75) not null,
		City varchar(30) not null,
		StateCode varchar(10) not null,
		PostalCode varchar(15) not null,
		Contact varchar(20) not null,
		AccountType varchar(50) not null,
		AccountStatus varchar(20) not null,
		LoanType varchar(50) not null,
		UnpaidBalance money default(0) not null,
		MonthlyPayment money default(0) not null,
		LateThirtyDays int default(0) not null,
		LateSixtyDays int default(0) not null,
		LateNinetyDays int default(0) not null,
		LateOneTwentyDays int default(0) not null,
		DateImported datetime,
		ImportedBy int,
		CreditLiabilityLookupID int null,
		primary key (CreditLiabilityID),
		foreign key (ReportID) references tblCreditReport(ReportID) on delete no action,
		foreign key (CreditSourceID) references tblCreditSource(CreditSourceID) on delete cascade
	)
end