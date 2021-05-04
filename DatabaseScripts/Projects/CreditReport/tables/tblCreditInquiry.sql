
if object_id('tblCreditInquiry') is null begin
	create table tblCreditInquiry
	(
		CreditInquiryID int identity(1,1) not null,
		CreditSourceID int not null,
		MadeBy varchar(300),
		InquiryDate datetime,
		primary key (CreditInquiryID),
		foreign key (CreditSourceID) references tblCreditSource(CreditSourceID) on delete cascade
	)
end 