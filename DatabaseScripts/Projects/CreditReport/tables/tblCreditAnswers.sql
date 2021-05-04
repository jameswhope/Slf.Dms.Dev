
create table tblCreditAnswers
(
	CreditAnswerID int identity(1,1) not null,
	CreditQuestionID int not null,
	Choice int not null,
	Value varchar(300) not null,
	primary key (CreditAnswerID),
	foreign key (CreditQuestionID) references tblCreditQuestions(CreditQuestionID) on delete cascade
) 