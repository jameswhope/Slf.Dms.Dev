 IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblT1Attorneys')
	BEGIN
CREATE TABLE  tblT1Attorneys
(
CompanyID int,
Name nvarchar(250),
Tier1Flag char(1),
Status nvarchar(50),
IsCommRecipient bit,
Created datetime,
LastModified datetime,
RowAdded datetime
)
END
GO 