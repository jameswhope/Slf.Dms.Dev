IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblRetainerFees')
	BEGIN
CREATE TABLE  tblRetainerFees
(
CommPayID int,
AccountNumber nvarchar(50),
Payor nvarchar(250),
Payee nvarchar(250),
PaymentDate datetime,
BatchDate datetime,
CreditorBalance money,
Pct2Amount money,
Pct8Amount money,
PaidOut money,
Balance money,
REGFullyPaid bit,
REGVoid datetime,
REGBounce datetime,
RPDepBounced datetime,
RPDepVoid datetime,
Creditor nvarchar(250),
RowAdded datetime
)
END
GO
