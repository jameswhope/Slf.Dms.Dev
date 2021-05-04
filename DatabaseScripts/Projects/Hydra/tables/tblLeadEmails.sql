
create table tblLeadEmails
(
	LeadEmailID int identity(1,1) not null,
	LeadApplicantID int not null,
	Email varchar(100) not null,
	[Subject] varchar(1000) not null,
	Body varchar(max),
	Type varchar(30),
	DateSent datetime default(getdate()) not null,
	SentBy int,
	DateRead datetime,
	DateUnsubscribed datetime,
	SuppressionListID int,
	UnsubscribeReason varchar(1000),
	primary key (LeadEmailID),
	foreign key (LeadApplicantID) references tblLeadApplicant(LeadApplicantID) on delete cascade,
	foreign key (SuppressionListID) references tblSuppressionList(SuppressionListID) on delete no action
) 