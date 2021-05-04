IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblSeedFees')
	BEGIN
CREATE TABLE  tblSeedFees
( 
BatchDate datetime,
CompanyID datetime,
Name nvarchar(250),
AgencyID int,
ClientID int,
Client nvarchar(250),
RegisterID int,
EntryTypeID int,
EntryType nvarchar(150),
RegisterAmount money,
PaymentAmount money,
InitialDraftYN bit,
BouncedReason nvarchar(250),
AccountStatusID int,
AccountStatus nvarchar(250),
AccountBalance money,
AccountNumber nvarchar(50),
Creditor nvarchar(250),
CommBatchID int,
CommScenID int,
CommRecID int,
CommRec nvarchar(250),
CommrecAmount money,
Voided datetime,
Void bit,
Bounced bit,
RowAdded datetime
)
END
GO