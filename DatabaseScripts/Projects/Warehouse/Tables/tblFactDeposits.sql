 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblFactDeposits')
	BEGIN
CREATE TABLE  tblFactDeposits
(
DepositDate datetime,
DepositKey int,
ClientID int,
CompanyID int,
AgencyID int,
DepositAmount money,
RowAdded datetime
)
	END
GO