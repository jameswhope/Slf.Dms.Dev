 /* 
	Current Call fields
	CallIKey
	DialerRetryAfter
	DialerLastRecycled
 */
 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadApplicant')
 BEGIN
	IF col_length('tblLeadApplicant', 'DialerStatusId') is null
		Alter table tblLeadApplicant Add DialerStatusId int not null default 0 
		
	IF col_length('tblLeadApplicant', 'LastViciStatusCode') is null
		Alter table tblLeadApplicant Add LastViciStatusCode varchar(20) null
		
	IF col_length('tblLeadApplicant', 'LastViciStatusDate') is null
		Alter table tblLeadApplicant Add LastViciStatusDate datetime null
		
	IF col_length('tblLeadApplicant', 'LastContacted') is null
		Alter table tblLeadApplicant Add LastContacted datetime null
		
	IF col_length('tblLeadApplicant', 'DialerCount') is null
		Alter table tblLeadApplicant Add DialerCount int not null default 0 	 	
		 
 END
 
