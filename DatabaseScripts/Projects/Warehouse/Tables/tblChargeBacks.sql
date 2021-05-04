IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblChargeBacks')
	BEGIN
CREATE TABLE  tblChargeBacks
(
BatchDate datetime,
AgencyID int,
AgencyName nvarchar(250),
CommRecID int,
CommissionRecipient nvarchar(250),
CompanyID int,
Company nvarchar(250),
ClientName nvarchar(250),
RegisterID int,
EntryTypeID int,
FeeAmount money,
PaymentAmount money,
InitialDraftYN bit,
StateChanged datetime,
State nvarchar(150),
BouncedReason nvarchar(150),
AccountStatusID int,
AccountStatus nvarchar(150),
AccountBalance money,
AccountNumber nvarchar(50),
Creditor nvarchar(250),
CommBatchID int,
CommScenID int,
ComissionPaid money,
RowAdded datetime
)
END
GO
 