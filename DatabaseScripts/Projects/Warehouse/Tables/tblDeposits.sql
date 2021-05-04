IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDeposits')
	BEGIN
CREATE TABLE  tblDeposits
(
RegisterID int,
ClientID int,
CompanyID int,
Company nvarchar(250),
AgencyID int,
Agency nvarchar(250),
ClientName nvarchar(250),
DepositDate datetime,
InitialDraftDate datetime,
InitialDraftYN bit,
InititalDraftAmount money,
StateChanged datetime,
State nvarchar(250),
bounceReason nvarchar(250),
EntryTypeID int,
DepositAmount money,
RowAdded datetime
)
END
GO
 