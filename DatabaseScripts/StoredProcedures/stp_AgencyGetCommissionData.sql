/****** Object:  StoredProcedure [dbo].[stp_AgencyGetCommissionData]    Script Date: 11/19/2007 15:26:51 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetCommissionData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetCommissionData]
(
	@agencyId int,
	@startDate datetime
)

AS

DECLARE @clientInfo TABLE
(
	ClientId int PRIMARY KEY,
	FullName varchar(102),
	Account varchar(15)
)

-- Get all the clients for this agent
-- TODO: limit down to only ones that have transactions
INSERT INTO
	@clientInfo
SELECT
	tblClient.ClientId,
	(LastName + ', ' + FirstName) AS FullName,
	AccountNumber
FROM
	tblClient INNER JOIN
	tblPerson ON tblClient.PrimaryPersonId=tblPerson.PersonId
WHERE
	AgencyId=@agencyId
ORDER BY
	FullName

SELECT
	ClientId,
	FullName,
	Account
FROM
	@clientInfo

DECLARE @endDate datetime
SET @endDate = DATEADD(MONTH, 1, @startDate)

DECLARE @transactionSummary TABLE
(
	RegisterId int,
	ClientId int,
	Amount float,
	Balance float,
	EntryTypeId int
)

-- Get all transactions from this month
INSERT INTO
	@transactionSummary
SELECT
	RegisterId,
	ClientId,
	Amount,
	Balance,
	EntryTypeId
FROM
	tblRegister
WHERE
	ClientId IN (SELECT ClientId FROM @clientInfo) AND
	TransactionDate >= @startDate AND
	TransactionDate < @endDate


SELECT
	ClientId,
	Amount,
	EntryTypeId
FROM
	@transactionSummary


-- Enrollment transaction detail
SELECT
	ClientId,
	( SELECT TOP 1 Balance FROM tblRegister WHERE ClientId=tbla.ClientID AND EntryTypeId=2 ORDER BY TransactionDate DESC
	) AS EndingBalance,
	( SELECT Amount FROM tblRegister WHERE ClientId=tbla.ClientID AND EntryTypeID=2
	) AS TotalFees,
	(SELECT Created FROM tblRoadmap WHERE 
		tblRoadmap.ClientId=tbla.ClientId
		AND tblRoadmap.ClientStatusId=5
	) AS EnrollDate
FROM
	@clientInfo as tbla
WHERE
	ClientId IN (SELECT ClientID FROM @transactionSummary WHERE EntryTypeId IN (2, 7))
ORDER BY
	FullName

-- Settlement transaction summary
SELECT
	ts.ClientId,
	(SELECT Balance FROM tblRegister WHERE 
		tblRegister.ClientId=ts.ClientId AND
		TransactionDate <  @endDate AND
		EntryTypeId=2
	) AS BeginBalance

FROM
	@transactionSummary ts INNER JOIN @clientInfo ci ON ci.ClientId=ts.ClientId
WHERE
	EntryTypeId IN (4)
ORDER BY
	FullName

-- Settlement transaction detail
SELECT
	tblAccount.ClientId, 
	tblAccount.CurrentCreditorInstanceId,
	(SELECT tblCreditor.[Name] FROM tblCreditorInstance INNER JOIN tblCreditor ON tblCreditorInstance.CreditorId=tblCreditor.CreditorId WHERE tblCreditorInstance.CreditorInstanceId=tblAccount.CurrentCreditorInstanceId) AS CreditorName,
	tblAccount.CurrentAmount,
	tblMediation.SettlementAmount as AmtOffered,
	SettlementFee AS SettFees
FROM
	tblAccount INNER JOIN tblMediation ON tblAccount.AccountId=tblMediation.AccountId
	
WHERE
	tblAccount.ClientId IN (SELECT ClientId FROM @transactionSummary WHERE EntryTypeId IN (4))
	AND Settled IS NOT NULL 
	AND	Settled >= @startDate 
	AND	Settled < @endDate
GO
