IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBofA_NACHAToOA')
	BEGIN
		DROP  Procedure  stp_GetBofA_NACHAToOA
	END

GO

CREATE Procedure stp_GetBofA_NACHAToOA
	(
		@AttorneyID int = 0
	)
AS
/********************************************************************************************
This is the NACHA transfer from the GCA to the OA accounts for All commission recipients
stp_GetBofA_NACHAToOA
********************************************************************************************/

DECLARE @AccountNumber varchar(50)
SET @AccountNumber = (SELECT RoutingNumber + AccountNumber FROM tblCommRec WHERE IsTrust = 1 and CompanyID = @AttorneyID)

DECLARE @NACHAToOADeposits TABLE
(
NachaRegisterID INT,
AttorneyNumber INT,
[Name] NVARCHAR(255),
ToRoutingNumber VARCHAR(9),
ToAccountNumber NVARCHAR(50),
Amount MONEY,
Checking_Savings VARCHAR(10)
)

INSERT INTO @NACHAToOADeposits
SELECT 
nr.NachaRegisterID,
c.CompanyID,
nr.[Name],
nr.RoutingNumber,
nr.AccountNumber,
nr.Amount,
nr.Type
FROM tblnacharegister nr
JOIN tblCompany c ON c.companyid = nr.companyid
LEFT JOIN tblCommRec cr ON cr.CompanyID = nr.companyid AND cr.istrust = 0 AND cr.abbreviation like '%OA%'
WHERE nr.idtidbit IS NULL
AND nr.ispersonal = 0
AND nr.CompanyID = @AttorneyID
AND nr.RoutingNumber + nr.AccountNumber <> @AccountNumber

INSERT INTO @NACHAToOADeposits
SELECT 
nr.NachaRegisterID,
c.CompanyID,
nr.[Name],
nr.RoutingNumber,
nr.AccountNumber,
nr.Amount,
nr.Type
FROM tblnacharegister2 nr
JOIN tblCompany c ON c.companyid = nr.companyid
JOIN tblCommRec cr ON cr.CompanyID = nr.companyid AND cr.istrust = 0 AND cr.abbreviation like '%OA%'
WHERE nr.nachafileid = -1
AND nr.ispersonal = 0
AND nr.CompanyID = @AttorneyID 

SELECT * FROM @NACHAToOADeposits


GO

/*
GRANT EXEC ON stp_GetBofA_NACHAToOA TO PUBLIC

GO
*/

