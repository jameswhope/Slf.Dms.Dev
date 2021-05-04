
if object_id('tblLeadVerification') is null begin
	create table tblLeadVerification
	(
		LeadVerificationID int identity(1,1) not null,
		LeadApplicantID int not null,
		PVN varchar(10),
		VDate char(8) not null,
		AccessNumber varchar(10),
		Result varchar(5),
		Submitted datetime default(getdate()) not null,
		SubmittedBy int not null,
		Completed datetime null,
		ConfNum varchar(30) null,
		ConfEntered datetime,
		primary key (LeadVerificationID),
		foreign key (LeadApplicantID) references tblLeadApplicant(LeadApplicantID) on delete cascade
	)
end 