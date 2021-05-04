IF NOT EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblCommissionRecipients')
	BEGIN
CREATE TABLE  tblCommissionRecipients
(
 CommRecID int,
Abbreviation nvarchar(50),
Display nvarchar(250),
Created datetime,
LastModified datetime,
RowAdded datetime
)
END
GO