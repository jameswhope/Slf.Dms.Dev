IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SingleStatementBuilder')
	BEGIN
		DROP  Procedure  stp_SingleStatementBuilder
	END

GO

CREATE Procedure stp_SingleStatementBuilder
@date1 SMALLDATETIME = NULL, 
	@days INT = 15,
	@CompanyID INT = -1,
	@AccountNumber INT = -1
AS
	BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	-- IF running AS a script use this, otherwise 
	-- use @date1 AS the parameter that needs to be passed.
--	DECLARE @date1 SMALLDATETIME
--	DECLARE @days INT
--	DECLARE @CompanyID INT
--	DECLARE @AccountNumber INT
--	
--	SET @date1 = '11/15/2008'
--	SET @days = 15
--	SET @CompanyID = -1
--	SET @AccountNumber = -1

     -- These are variables FOR the process
	DECLARE @date2 SMALLDATETIME
	DECLARE @day1 INT
	DECLARE @day2 INT
	DECLARE @EOM INT
	DECLARE @RealDays INT
	DECLARE @AcctNo NVARCHAR(255)
	DECLARE @Name NVARCHAR(255)
	DECLARE @OrigAcctNo NVARCHAR(255)
	DECLARE @Status NVARCHAR(255)
	DECLARE @Balance MONEY
	DECLARE @Amount MONEY
	DECLARE @FROM SMALLDATETIME
	DECLARE @To SMALLDATETIME
	DECLARE @SDABalance MONEY
	DECLARE @PFOBalance MONEY
	DECLARE @cid INT
	DECLARE @cslocation2 NVARCHAR(255)
	DECLARE @PmtDate1 SMALLDATETIME
	DECLARE @PmtDate2 SMALLDATETIME
	DECLARE @DepositDate NVARCHAR(50)
	DECLARE @DateDiff INT

		IF @date1 IS NULL
		BEGIN
			SET @date1 = GETDATE()
			SET @DateDiff = DATEPART(DAY, @date1)
			IF DATEPART(DAY, @date1) <= 15
				BEGIN
					SET @date1 = DATEADD(DAY, -(@DateDiff - 1), @date1)
				END
			IF DATEPART(DAY, @date1) >= 16
				BEGIN
					SET @DateDiff = @DateDiff - 15
					SET @date1 = DATEADD(DAY, - @DateDiff, @date1)
				END
		END

-- Statements FOR procedure follow
	SET @day1 = DATEPART(DAY,@date1)
	SET @day2 = DATEPART(DAY,@date2)

	-- Determine the To AND FROM dates
	SET @EOM = DAY(DATEADD(DAY,-1,DATEADD(MONTH,1,DATEADD(DAY,1-DAY(@date1),@date1))))
	IF DATEPART(DAY, @date1) >= 15
		BEGIN
			SET @RealDays = @EOM - DATEPART(DAY, @date1)
		END
	ELSE
		BEGIN
			SET @RealDays = @days - 1
		END

	SET @date2 = DATEADD(DAY, @realdays, @date1)
	
	-- Determine the To AND FROM dates
	-- Start with Feb
IF DATEPART(DAY, @date1) >= 15
		BEGIN
			SET @RealDays = @EOM - DATEPART(DAY, @date1)
		END
	ELSE
		BEGIN
			SET @RealDays = @days - 1
		END

	SET @date2 = DATEADD(DAY, @realdays, @date1)
	
	-- Calculate date 2 FROM the count of days
	IF DATEPART(DAY, @date1) = 1
		BEGIN
		SET @day1 = 16
		SET @day2 = 31 --@eom
		END
	ELSE
		BEGIN
		SET @day1 = 1
		SET @day2 = 15
		END
		
	IF @day1 = 1 AND @eom = 31
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, 2 + (@eom - @realdays), @date1)
			SET @PmtDate2 = DATEADD(DAY, @EOM, @date1)
		END
	IF @day1 = 16 AND @eom = 31
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, 15, @date1)
			SET @PmtDate2 = DATEADD(DAY, 15, @PmtDate1)
		END

	IF @day1 = 1 AND @eom = 30
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, 1 + (@eom - @realdays), @date1)
			SET @PmtDate2 = DATEADD(DAY, @EOM, @date1)
		END
	IF @day1 = 16 AND @eom = 30
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, 15, @date1)
			SET @PmtDate2 = DATEADD(DAY, 14, @PmtDate1)
		END

	IF @day1 = 1 AND @eom = 28
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, (@eom - @realdays)-1, @date1)
			SET @PmtDate2 = DATEADD(DAY, @EOM, @date1)
		END
	IF @day1 = 16 AND @eom = 28
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, 15, @date1)
			SET @PmtDate2 = DATEADD(DAY, 12, @PmtDate1)
		END

	IF @day1 = 1 AND @eom = 29
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, (@eom - @realdays), @date1)
			SET @PmtDate2 = DATEADD(DAY, @EOM, @date1)
		END
	IF @day1 = 16 AND @eom = 29
		BEGIN
			SET @PmtDate1 = DATEADD(DAY, 15, @date1)
			SET @PmtDate2 = DATEADD(DAY, 13, @PmtDate1)
		END

IF DATEPART(MONTH, @date1) = 2
	BEGIN
		IF DATENAME(DAY, @date2) = 28
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date2)
				SET @FROM = DATEADD(DAY, - @realdays + 1, @FROM)
				SET @To = DATEADD(DAY,0, @date1)
			END
		ELSE
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date1)
				SET @To = DATEADD(DAY,-1,@date1)
			END
	END

IF DATEPART(MONTH, @date1) = 2
	BEGIN
		IF DATENAME(DAY, @date2) = 29
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date2)
				SET @FROM = DATEADD(DAY, - @realdays + 1, @FROM)
				SET @To = DATEADD(DAY,0, @date1)
			END
		ELSE
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date1)
				SET @To = DATEADD(DAY,-1,@date1)
			END
	END

IF DATEPART(MONTH, @date1) IN (1,3,5,7,8,10,12)
	BEGIN
		IF DATENAME(DAY, @date2) = 31
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date1)
				SET @FROM = DATEADD(DAY, 1, @FROM)
				SET @To = DATEADD(DAY,0, @date1)
			END
		ELSE
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date1)
				SET @To = DATEADD(DAY,-1,@date1)
			END
	END

IF DATEPART(MONTH, @date1) IN (4,6,9,11)
	BEGIN
		IF DATENAME(DAY, @date2) = 30
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date1)
				SET @FROM = DATEADD(DAY, 1, @FROM)
				SET @To = @date1
			END
		ELSE
			BEGIN
				SET @FROM = DATEADD(MONTH, -1, @date1)
				SET @To = DATEADD(DAY,-1,@date1)
			END
	END
	
--Lets clean up the tblSingleStatementResults before running

truncate TABLE tblSingleStatementResults

IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.tables WHERE table_name = 'tblSingleStatementPersonal')
	BEGIN
		DROP TABLE tblSingleStatementPersonal
	END

-- OK get the clients to process based ON companyid, accountno or all

-- First is there a company id to process FOR? IF so the account number should be -1

IF @CompanyID > -1 AND @AccountNumber <= -1
	BEGIN
		SELECT  c.clientid,
			c.accountnumber,
			c.companyid AS [BaseCompany],
			p.firstname + ' ' + p.lastname AS [Name],
			p.street + ' ' + ISNULL(p.street2,'') AS [Street],
			p.city AS [City],
			s.abbreviation AS [ST],
			LEFT(p.zipcode,5) AS [Zip],
			CONVERT(VARCHAR, @FROM, 101) + ' To ' + CONVERT(VARCHAR, @To, 101) AS [period],
			case DATEPART(DAY, @date1) WHEN 15 THEN DATENAME(MONTH,DATEADD(MONTH, 1, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,DATEPART(YEAR, @date1)) ELSE DATENAME(MONTH,DATEADD(MONTH, 0, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,DATEPART(YEAR, @date1)) END AS  [DepDate],
			c.depositamount AS [DepAmt],
		-ISNULL((
				SELECT 
					SUM(amount) 
				FROM 
					tblRegister INNER JOIN
					tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
				WHERE 
					tblRegister.Clientid=c.ClientId AND
					tblEntryType.Fee=1)
			,0)
			-
			ISNULL((
				SELECT 
					SUM(tblregisterpayment.amount) 
				FROM 
					tblRegisterPayment INNER JOIN
					tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
				WHERE 
					tblRegister.Clientid=c.ClientId)
			,0) AS PFOBalance,
			CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
			CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
			CASE c.CompanyID WHEN 1 THEN co.Name WHEN 2 THEN co.NAME ELSE p.firstname + ' ' + p.lastname + ', Acct.# ' + c.AccountNumber END [Payee],
			ca.address1 AS [cslocation1],
			(ca.city + ', ' + ca.state + ' ' + ca.zipcode) AS [cslocation2],
			cp.PhoneNumber  AS [desc1],
			co.BillingMessage AS [desc2],
			' ' AS [desc3]

INTO tblSingleStatementPersonal

		 FROM tblClient c INNER JOIN
			tblPerson p ON c.primarypersonid = p.personid LEFT JOIN
			tblState s ON p.stateid = s.stateid INNER JOIN
			tblCompany co ON co.companyid = c.companyid INNER JOIN 
			tblCompanyAddresses ca ON c.companyid = ca.companyid INNER JOIN
			tblcompanyphones cp ON c.companyid = cp.companyid
		WHERE
			NOT c.currentclientstatusid IN (15, 17, 18) 
			AND c.VWUWResolved IS NOT NULL 
			AND not c.accountnumber IS NULL
			AND not c.accountnumber = ''
			AND c.depositday >= @day1
			AND c.depositday <= @day2
			AND ca.addresstypeid = 3
			AND cp.phonetype = 46
			AND co.CompanyID = @CompanyID
	END

-- IF neither the account number
IF @CompanyID <= -1 AND @AccountNumber <= -1
	BEGIN
		SELECT  c.clientid,
			c.accountnumber,
			c.companyid AS [BaseCompany],
			p.firstname + ' ' + p.lastname AS [Name],
			p.street + ' ' + ISNULL(p.street2,'') AS [Street],
			p.city AS [City],
			s.abbreviation AS [ST],
			LEFT(p.zipcode,5) AS [Zip],
			CONVERT(VARCHAR, @FROM, 101) + ' To ' + CONVERT(VARCHAR, @To, 101) AS [period],
			case DATEPART(DAY, @date1) WHEN 15 THEN DATENAME(MONTH,DATEADD(MONTH, 1, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,DATEPART(YEAR, @date1)) ELSE DATENAME(MONTH,DATEADD(MONTH, 0, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,DATEPART(YEAR, @date1)) END AS  [DepDate],
			c.depositamount AS [DepAmt],
		-ISNULL((
				SELECT 
					SUM(amount) 
				FROM 
					tblRegister INNER JOIN
					tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
				WHERE 
					tblRegister.Clientid=c.ClientId AND
					tblEntryType.Fee=1)
			,0)
			-
			ISNULL((
				SELECT 
					SUM(tblregisterpayment.amount) 
				FROM 
					tblRegisterPayment INNER JOIN
					tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
				WHERE 
					tblRegister.Clientid=c.ClientId)
			,0) AS PFOBalance,
			CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
			CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
			CASE c.CompanyID WHEN 1 THEN co.Name WHEN 2 THEN co.NAME ELSE p.firstname + ' ' + p.lastname + ', Acct.# ' + c.AccountNumber END [Payee],
			ca.address1 AS [cslocation1],
			(ca.city + ', ' + ca.state + ' ' + ca.zipcode) AS [cslocation2],
			cp.PhoneNumber  AS [desc1],
			co.BillingMessage AS [desc2],
			' ' AS [desc3]

INTO tblSingleStatementPersonal

		 FROM tblClient c INNER JOIN
			tblPerson p ON c.primarypersonid = p.personid LEFT JOIN
			tblState s ON p.stateid = s.stateid INNER JOIN
			tblCompany co ON co.companyid = c.companyid INNER JOIN 
			tblCompanyAddresses ca ON c.companyid = ca.companyid INNER JOIN
			tblcompanyphones cp ON c.companyid = cp.companyid
		WHERE
			NOT c.currentclientstatusid IN (15, 17, 18) 
			AND c.VWUWResolved IS NOT NULL 
			AND not c.accountnumber IS NULL
			AND not c.accountnumber = ''
			AND c.depositday >= @day1
			AND c.depositday <= @day2
			AND ca.addresstypeid = 3
			AND cp.phonetype = 46
	END

IF @AccountNumber > -1 AND @CompanyID <= -1
	BEGIN
		SELECT  c.clientid,
			c.accountnumber,
			c.companyid AS [BaseCompany],
			p.firstname + ' ' + p.lastname AS [Name],
			p.street + ' ' + ISNULL(p.street2,'') AS [Street],
			p.city AS [City],
			s.abbreviation AS [ST],
			LEFT(p.zipcode,5) AS [Zip],
			CONVERT(VARCHAR, @FROM, 101) + ' To ' + CONVERT(VARCHAR, @To, 101) AS [period],
			case DATEPART(DAY, @date1) WHEN 15 THEN DATENAME(MONTH,DATEADD(MONTH, 1, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,DATEPART(YEAR, @date1)) ELSE DATENAME(MONTH,DATEADD(MONTH, 0, @date1)) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,DATEPART(YEAR, @date1)) END AS  [DepDate],
			c.depositamount AS [DepAmt],
		-ISNULL((
				SELECT 
					SUM(amount) 
				FROM 
					tblRegister INNER JOIN
					tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
				WHERE 
					tblRegister.Clientid=c.ClientId AND
					tblEntryType.Fee=1)
			,0)
			-
			ISNULL((
				SELECT 
					SUM(tblregisterpayment.amount) 
				FROM 
					tblRegisterPayment INNER JOIN
					tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
				WHERE 
					tblRegister.Clientid=c.ClientId)
			,0) AS PFOBalance,
			CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
			CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
			CASE c.CompanyID WHEN 1 THEN co.Name WHEN 2 THEN co.NAME ELSE p.firstname + ' ' + p.lastname + ', Acct.# ' + c.AccountNumber END [Payee],
			ca.address1 AS [cslocation1],
			(ca.city + ', ' + ca.state + ' ' + ca.zipcode) AS [cslocation2],
			cp.PhoneNumber  AS [desc1],
			co.BillingMessage AS [desc2],
			' ' AS [desc3]

INTO tblSingleStatementPersonal

		 FROM tblClient c INNER JOIN
			tblPerson p ON c.primarypersonid = p.personid LEFT JOIN
			tblState s ON p.stateid = s.stateid INNER JOIN
			tblCompany co ON co.companyid = c.companyid INNER JOIN 
			tblCompanyAddresses ca ON c.companyid = ca.companyid INNER JOIN
			tblcompanyphones cp ON c.companyid = cp.companyid
		WHERE
			NOT c.currentclientstatusid IN (15, 17, 18)
			AND c.VWUWResolved IS NOT NULL 
			AND not c.accountnumber IS NULL
			AND not c.accountnumber = ''
			AND c.depositday >= @day1
			AND c.depositday <= @day2
			AND ca.addresstypeid = 3
			AND cp.phonetype = 46
			AND c.AccountNumber = @AccountNumber
	END

--TABLE Creditor
--Modified 06/22/2009 J Hope to use data from tblAccount for balances not tblSingleCreditorInstance
IF EXISTS 
	(SELECT * FROM INFORMATION_SCHEMA.tables WHERE table_name = 'tblSingleStatementCreditor')
	BEGIN
		DROP TABLE tblSingleStatementCreditor
	END
	
	CREATE TABLE tblSingleStatementCreditor
		(
			Acct_No NVARCHAR(255),
			Cred_Name NVARCHAR(255),
			Orig_Acct_No NVARCHAR(255),
			Status NVARCHAR(255),
			Balance MONEY
		)

DECLARE cursor_Creditor CURSOR FOR

SELECT 
	c.accountnumber [ClntAcctNo],
	cr.name [Cred. Name],
	ciOrig.accountnumber [Acct #],
	ISNULL(s.code, '') [Status],
	a.CurrentAmount [Balance]
FROM 
	tblAccount a
	INNER JOIN tblClient c ON a.clientid = c.clientid
	INNER JOIN tblCreditorInstance ciOrig ON ciOrig.CreditorInstanceID=
		(SELECT 
			TOP 1 CreditorInstanceId 
		FROM 
			tblCreditorInstance 
		WHERE 
			AccountID=a.AccountID 
		ORDER BY 
			Acquired ASC)
	INNER JOIN tblCreditor cr ON ciOrig.creditorid = cr.creditorid
	LEFT OUTER JOIN tblAccountStatus s ON a.accountStatusID = s.accountstatusid
WHERE
	c.clientid IN (SELECT clientid FROM tblSingleStatementPersonal)

OPEN cursor_Creditor

FETCH NEXT FROM cursor_Creditor INTO @AcctNo, @Name, @OrigAcctNo, @Status, @Balance

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO tblSingleStatementCreditor
		(
			Acct_No,
			Cred_Name,
			Orig_Acct_No,
			Status,
			Balance
		)
		VALUES
		(
			@AcctNo,
			@Name,
			@OrigAcctNo,
			@Status,
			@Balance
		)
		FETCH NEXT FROM cursor_Creditor INTO @AcctNo, @Name, @OrigAcctNo, @Status, @Balance
	END

--CLOSE up this CURSOR
CLOSE cursor_Creditor
DEALLOCATE cursor_Creditor

--Results TABLE FOR the statements

DECLARE cursor_statementRes CURSOR FOR
SELECT ClientID
FROM tblSingleStatementPersonal

OPEN cursor_statementRes

FETCH NEXT FROM cursor_statementRes INTO @cid
WHILE @@FETCH_STATUS = 0
BEGIN
	--print @cid
	EXEC stp_GetSingleStatementForClient @cid, @From, @To
	FETCH NEXT FROM cursor_statementRes INTO @cid
END
CLOSE cursor_statementRes
DEALLOCATE cursor_statementRes
END

GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

