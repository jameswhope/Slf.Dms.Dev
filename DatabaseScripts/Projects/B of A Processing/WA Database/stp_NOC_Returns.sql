IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NOC_Returns')
	BEGIN
		DROP  Procedure  stp_NOC_Returns
	END

GO

CREATE PROCEDURE [dbo].[stp_NOC_Returns] 
	-- Add the parameters for the stored procedure here
	@StartDate DATETIME = '01/01/1900', 
	@EndDate DATETIME = '01/01/2050',
	@ClientID INT = 0,
	@AccountNumber VARCHAR(50) = '',
	@ReportID INT = 1
AS
BEGIN

	--For Testing
--	DECLARE @StartDate DATETIME
--	SET @StartDate = '06/23/2010' 
--	DECLARE @EndDate DATETIME
--	SET @EndDate = '01/1/2050'
--	DECLARE @ClientID INT 
--	SET @ClientID = 0
--	DECLARE @AccountNumber VARCHAR(50)
--	SET @AccountNumber = ''
--  DECLARE @ReportID INT
--  SET @ReportID = 1

	SET NOCOUNT ON;
	DECLARE @ReportDate DATETIME
	SET @ReportDate = @StartDate

	DECLARE @NOC1ID INT
	DECLARE @NOC5ID INT
	DECLARE @NOC6ID INT
	DECLARE @LawFirm VARCHAR(50)
	DECLARE @SettlementDate VARCHAR(15)
	DECLARE @SearchableStartDate VARCHAR(10)
	DECLARE @SearchableEndDate VARCHAR(10)
	DECLARE @DateHolder VARCHAR(15)
	DECLARE @SettlementAtty VARCHAR(150)
	DECLARE @Amount VARCHAR(50)

	SET @SearchableStartDate = CONVERT(VARCHAR(10), @ReportDate, 101) --12
	SET @SearchableEndDate = CONVERT(VARCHAR(10), @EndDate, 101) --12

	DECLARE @ReturnedItems TABLE (
	ReportDetailID INT,
	ReportID INT,
	TransactionID VARCHAR(50),
	DepositType VARCHAR(50),
	[Status] VARCHAR(50),
	ClientID INT,
	ClientName VARCHAR(150),
	CheckNumber VARCHAR(50),
	AccountNo VARCHAR(50),
	RegisterID INT,
	Amount MONEY,
	ReasonCode VARCHAR(50),
	Bounced VARCHAR(50),
	RoutingNumber VARCHAR(9),
	AccountNumber VARCHAR(50),
	LawFirm VARCHAR(50),
	Agency VARCHAR(50),
	CIDRep VARCHAR(100),
	BankType VARCHAR(50),
	Bank VARCHAR(150))

--	SettlementDate VARCHAR(50),
--	BouncedDesription VARCHAR(50),
--	BouncedDate VARCHAR(50))

	--Get the date setup first
	DECLARE big_cur CURSOR FOR
	SELECT 
	Created,
	NOC1ID,
	CompanyName
	FROM tblNOC1 
	WHERE Created BETWEEN @SearchableStartDate AND @SearchableEndDate

	OPEN big_cur

	FETCH NEXT FROM big_cur INTO @DateHolder, @NOC1ID, @LawFirm
	WHILE @@FETCH_STATUS = 0
	BEGIN

		--Begin selecting the individual data pieces
		DECLARE cur CURSOR FOR
		SELECT
		NOC5ID,
		CompanyName,
		SettlementDate
		FROM tblNOC5
		WHERE NOC1ID = @NOC1ID

		OPEN cur 

		FETCH NEXT FROM cur INTO @NOC5ID, @LawFirm, @SettlementDate
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @Amount = RIGHT(Amount, LEN(Amount)+1 - PATINDEX('%[^0]%', Amount)) 
			FROM tblNOC6 
			WHERE NOC5ID = @NOC5ID

			INSERT INTO @ReturnedItems
			SELECT
			@NOC1ID,
			@ReportID,
			n6.TraceNumber,
			'ACH',
			'Returned', 
			c.ClientID,
			p.FirstName + ' ' + p.LastName,
			'Unknown',
			c.AccountNumber,
			n6.IndividualIDNumber,
			LEFT(RIGHT(n6.Amount, LEN(n6.Amount)+1 - PATINDEX('%[^0]%', n6.Amount)), LEN(n6.Amount)+1 - PATINDEX('%[^0]%', n6.Amount)-2) + '.' + RIGHT(n6.Amount, 2),
			n7.ReturnreasonCode,
			CASE WHEN r.Bounce IS NULL THEN r2.Bounce ELSE r.Bounce END,
			n6.RoutingNumber + n6.checkdigit,
			n6.AccountNumber,
			@LawFirm,
			a.[Name],
			c.AgentName,
			'C',
			c.BankName
--			CASE WHEN @SettlementDate <> ''000'' THEN RIGHT(LEFT(@SettlementDate, 4), 2) + ''/'' + RIGHT(@SettlementDate, 2) + ''/20'' + LEFT(@SettlementDate, 2) ELSE '''' END,
--			br.BouncedDescription,
			
			FROM tblNOC6 n6
			LEFT JOIN [DMS].[dbo].[tblNACHARegister] nr ON nr.NachaRegisterID = n6.IndividualIDNumber
			LEFT JOIN [DMS].[dbo].[tblNACHARegister2] nr2 ON nr2.NachaRegisterID = n6.IndividualIDNumber
			LEFT JOIN [DMS].[dbo].[tblClient] c ON c.ClientID = nr.ClientID
			LEFT JOIN [DMS].[dbo].[tblPerson] p ON p.ClientID = c.ClientID AND p.Relationship = 'Prime'
			LEFT JOIN [DMS].[dbo].[tblAgency] a ON a.AgencyID = c.AgencyID
			LEFT JOIN tblNOC7 n7 ON n7.NOC6ID = n6.NOC6ID
			LEFT JOIN [DMS].[dbo].[tblBouncedReasons] br ON br.BouncedCode = n7.ReturnReasonCode
			LEFT JOIN [DMS].[dbo].[tblRegister] r ON r.RegisterID = nr.RegisterID
			LEFT JOIN [DMS].[dbo].[tblRegister] r2 ON r2.registerID = nr2.RegisterID
			WHERE n6.NOC5ID = @NOC5ID
			AND n6.Amount <> '0000000000'

		FETCH NEXT FROM cur INTO @NOC5ID, @LawFirm, @SettlementDate
		END

		CLOSE cur
		DEALLOCATE cur

	FETCH NEXT FROM big_cur INTO @DateHolder, @NOC1ID, @LawFirm
	END

	CLOSE big_cur
	DEALLOCATE big_cur

	SELECT DISTINCT * FROM @ReturnedItems WHERE AccountNo IS NOT NULL ORDER BY AccountNumber

END

