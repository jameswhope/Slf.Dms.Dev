 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblTransactions')
	BEGIN
CREATE TABLE  tblTransactions
(
PaidTo nvarchar(250),
DebitCredit nvarchar(6),
EntryTypeName nvarchar(250),
EntryTypeID int,
ClientCreated datetime,
ClientID int,
CompanyID int,
AgencyID int,
CommScenID int,
RegisterCreated datetime,
TransactionDate datetime,
RegisterID int,
RegisterAmount money,
Bounce bit,
BouncedReason nvarchar(250),
Void bit,
RegisterPaymentID int,
PaymentDate datetime,
CommPayID int,
[Percent] decimal(18, 0),
CommPayAmount money,
CommBatchID int,
CommChargebackID int,
ChargeBackDate datetime,
ChargebackAmount money,
ChargeBackCommPayID int,
CommRecID int,
BatchDate datetime,
RowAdded datetime
)
END
GO