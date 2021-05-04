IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblLeadDialerCall')
	BEGIN
		CREATE TABLE tblLeadDialerCall
		(
		   CallMadeId int not null identity(1,1) Primary Key Clustered,
		   LeadApplicantId int not null,
		   PhoneNumber varchar(20) not null,
		   Created datetime not null default Getdate(),
		   CreatedBy int not null,
		   Exception varchar(max) null,
		   CallIdKey varchar(20) null,
		   OutboundCallKey varchar(20) null,
		   PickedupDate datetime null,
		   PickedupBy int null
		)
	END
GO


 