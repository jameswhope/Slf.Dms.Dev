IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAttorneys')
	BEGIN
CREATE TABLE  tblAttorneys
(
AttorneyID int,
CompanyID int,
States nvarchar(50),
FirstName nvarchar(50),
MiddleName nvarchar(50),
LastName nvarchar(50),
Suffix nvarchar(10),
StartDate datetime,
FullName nvarchar(250),
Created datetime,
LastModified datetime,
StatePrimary bit,
RowAdded datetime
)
END
GO
 