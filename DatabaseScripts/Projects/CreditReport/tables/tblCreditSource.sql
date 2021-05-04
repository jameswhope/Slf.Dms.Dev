
create table tblCreditSource
(
	CreditSourceID int identity(1,1) not null,
	ReportID int not null,
	SSN char(9) not null,
	FirstName varchar(30),
	LastName varchar(50),
	--CreditScore int default(0) not null,
	--CreditSource varchar(30),
	CoBorrower bit default(0) not null,
	primary key (CreditSourceID),
	foreign key (ReportID) references tblCreditReport(ReportID) on delete cascade
)
go

insert tblcreditsource (reportid,ssn,creditscore,creditsource)
select reportid,ssn,creditscore,creditsource
from tblcreditreport
go

update tblcreditliability
set creditsourceid = s.creditsourceid
from tblcreditliability l
join tblcreditsource s on s.reportid = l.reportid
where l.creditsourceid is null
go

alter table tblcreditreport drop column ssn
go

alter table tblcreditreport drop DF__tblCredit__Credi__558DDC7A
go

alter table tblCreditSource drop column creditscore
go

alter table tblCreditSource drop column creditsource
go 

alter table tblCreditSource add Equifax int
go

alter table tblCreditSource add Experian int
go

alter table tblCreditSource add TransUnion int
go