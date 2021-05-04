
create table tblCreditQuestions
(
	CreditQuestionID int identity(1,1) not null,
	CreditReportId varchar(30) not null,
	Question varchar(max) not null,
	Seq int not null,
	Answer int null,
	primary key (CreditQuestionID)
) 