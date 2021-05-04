 IF Not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblClients')
	BEGIN
CREATE TABLE tblClients
(ClientID int,	
AgencyID int,	
CompanyID int,	
AccountNumber int,	
DepositMethod nvarchar(50),	
DepositDay int,	
CurrentClientStatusID int,	
DepositStartDate datetime,	
InitialAgencyPercent money,	
InitialDraftDate datetime,	
InitialDraftAmount money,	
ApplicantName varchar(250),	
Created datetime,	
LastModified datetime,	
DepositAmount money,	
StateID int,	
ClientStatusDescription nvarchar(250),	
LastStatusDate datetime,	
RowAdded datetime)	
END
GO
