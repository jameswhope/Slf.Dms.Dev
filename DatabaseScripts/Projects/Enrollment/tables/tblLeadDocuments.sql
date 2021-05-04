
create table tblLeadDocuments
(
	LeadDocumentID int identity(1,1) not null,
	LeadApplicantID int not null,
	DocumentId varchar(50),
	AuthToken varchar(50),
	Submitted datetime default(getdate()) not null,
	SubmittedBy int not null,
	SignatoryEmail varchar(75),
	CurrentStatus varchar(50),
	Completed datetime,
	DocumentTypeID int not null,
	primary key (LeadDocumentID),
	foreign key (LeadApplicantID) references tblLeadApplicant(LeadApplicantID) on delete no action
) 