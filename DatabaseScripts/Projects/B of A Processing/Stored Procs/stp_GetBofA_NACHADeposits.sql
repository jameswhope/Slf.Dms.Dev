IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetBofA_NACHADeposits')
	BEGIN
		DROP  Procedure  stp_GetBofA_NACHADeposits
	END

GO

CREATE Procedure stp_GetBofA_NACHADeposits
	(
		@AttorneyID int

	)
AS
/****************************************************************************
This is the client NACHA payments into the clients deposit accounts
stp_GetBofA_NACHADeposits
****************************************************************************/

DECLARE @NACHADeposits TABLE
(
NachaRegisterID INT,
ClientAccountNumber INT,
[Name] NVARCHAR(255),
RoutingNumber VARCHAR(9),
AccountNumber NVARCHAR(50),
Amount MONEY,
Checking_Savings nvarchar(10)
)

INSERT INTO @NACHADeposits
SELECT 
nr.NachaRegisterID,
c.AccountNumber,
nr.[Name],
nr.RoutingNumber,
nr.AccountNumber,
nr.Amount,
nr.Type
FROM tblnacharegister nr
JOIN tblClient c ON c.clientid = nr.clientid
WHERE nr.idtidbit IS NULL
AND nr.ispersonal = 1
AND nr.CompanyID = @AttorneyID


INSERT INTO @NACHADeposits
SELECT 
nr.NachaRegisterID,
c.AccountNumber,
nr.[Name],
nr.RoutingNumber,
nr.AccountNumber,
nr.Amount,
nr.Type
FROM tblnacharegister2 nr
JOIN tblClient c ON c.clientid = nr.clientid
WHERE nr.nachafileid = -1
AND nr.ispersonal = 1
AND nr.CompanyID = @AttorneyID 

SELECT * FROM @NACHADeposits

GO

/*
GRANT EXEC ON stp_GetBofA_NACHADeposits TO PUBLIC

GO
*/

