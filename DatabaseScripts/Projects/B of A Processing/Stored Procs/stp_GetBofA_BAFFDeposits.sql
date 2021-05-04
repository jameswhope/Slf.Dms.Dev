IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBofA_BAFFDeposits')
	BEGIN
		DROP  Procedure  stp_GetBofA_BAFFDeposits
	END

GO

CREATE Procedure stp_GetBofA_BAFFDeposits
	(
		@AttorneyID int
	)
AS
/*********************************************************************
Transfer from Escrow account to GCA using BAFF format
stp_GetBofA_BAFFDeposits
**********************************************************************/

DECLARE @AccountNumber varchar(50)
SET @AccountNumber = (SELECT RoutingNumber + AccountNumber FROM tblCommRec WHERE IsTrust = 1 and CompanyID = @AttorneyID)

DECLARE @BAFFDeposits TABLE
(
NachaRegisterID INT,
AttorneyNumber INT,
[Name] NVARCHAR(255),
FromRoutingNumber VARCHAR(9),
FromAccountNumber NVARCHAR(50),
ToRoutingNumber nvarchar(9),
ToAccountNumber varchar(50),
Amount MONEY,
Checking_Savings varchar(10)
)

INSERT INTO @BAFFDeposits
SELECT 
nr.NachaRegisterID,
c.CompanyID,
nr.[Name],
nr.RoutingNumber,
nr.AccountNumber,
cr.RoutingNumber,
cr.AccountNumber,
nr.Amount,
nr.Type
FROM tblnacharegister nr
JOIN tblCompany c ON c.companyid = nr.companyid
JOIN tblCommRec cr ON cr.CompanyID = nr.companyid AND cr.istrust = 0 AND cr.abbreviation like '%GCA%'
WHERE nr.idtidbit IS NULL
AND nr.ispersonal = 0
AND nr.CompanyID = @AttorneyID
AND nr.RoutingNumber + nr.AccountNumber = @AccountNumber
AND nr.Amount < 0.00

INSERT INTO @BAFFDeposits
SELECT 
nr.NachaRegisterID,
c.CompanyID,
nr.[Name],
nr.RoutingNumber,
nr.AccountNumber,
cr.RoutingNumber,
cr.AccountNumber,
nr.Amount,
nr.Type
FROM tblnacharegister2 nr
JOIN tblCompany c ON c.companyid = nr.companyid
JOIN tblCommRec cr ON cr.CompanyID = nr.companyid AND cr.istrust = 0 AND cr.abbreviation like '%GCA%'
WHERE nr.nachafileid = -1
AND nr.ispersonal = 0
AND nr.CompanyID = @AttorneyID 
AND nr.RoutingNumber + nr.AccountNumber = @AccountNumber
AND nr.Amount < 0.00

SELECT * FROM @BAFFDeposits

GO

/*
GRANT EXEC ON stp_GetBofA_BAFFDeposits TO PUBLIC

GO
*/

