 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblFactFees')
	BEGIN
CREATE TABLE  tblFactFees
(
FeeKey int, 
DateKey datetime,
CommRecID int,
CommissionPaid money,
BatchDate datetime,
ClientID int,
RowAdded datetime
)
END
GO