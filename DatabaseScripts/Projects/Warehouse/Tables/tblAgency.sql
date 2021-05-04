 IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblAgencys')
	BEGIN
CREATE TABLE  tblAgencys
(
LastModified datetime,
AgencyID int,
Name nvarchar(250),
Created datetime,
CommScenID int,
RowAdded datetime
)
END
GO
