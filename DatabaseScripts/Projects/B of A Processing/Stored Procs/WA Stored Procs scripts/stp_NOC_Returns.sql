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
	@AccountNumber VARCHAR(50) = ''
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ReportDate DATETIME
	SET @ReportDate = @StartDate

	DECLARE @NOC1ID INT
	DECLARE @NOC5ID INT
	DECLARE @NOC6ID INT
	DECLARE @LawFirm VARCHAR(50)
	DECLARE @SettlementDate VARCHAR(15)
	DECLARE @SearchableStartDate VARCHAR(6)
	DECLARE @SearchableEndDate VARCHAR(6)
	DECLARE @DateHolder VARCHAR(15)
	DECLARE @SettlementAtty VARCHAR(150)
	DECLARE @Amount VARCHAR(50)

	SET @SearchableStartDate = CONVERT(NVARCHAR(8), @ReportDate, 12)
	SET @SearchableEndDate = CONVERT(NVARCHAR(8), @EndDate, 12)

	DECLARE @ReturnedItems TABLE (
	ClientID INT,
	RegisterID INT,
	AccountNo VARCHAR(50),
	ClientName VARCHAR(150),
	RoutingNumber VARCHAR(9),
	AccountNumber VARCHAR(50),
	Amount VARCHAR(50),
	LawFirm VARCHAR(50),
	SettlementDate VARCHAR(50),
	BouncedDesription VARCHAR(50),
	BouncedDate VARCHAR(50))

	DECLARE c_Range CURSOR FOR 
	SELECT 
	RIGHT(LEFT(FileCreationDate, 4), 2) + '/' + RIGHT(FileCreationDate, 2) + '/20' + LEFT(FileCreationDate, 2),
	NOC1ID,
	CompanyName
	FROM tblNOC1 
	WHERE FileCreationDate BETWEEN @SearchableStartDate AND @SearchableEndDate

	OPEN c_Range

		FETCH NEXT FROM c_Range INTO @DateHolder, @NOC1ID, @LawFirm
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
					c.ClientID,
					n6.IndividualIDNumber,
					c.AccountNumber,
					n6.IndividualName,
					n6.RoutingNumber,
					n6.AccountNumber,
					LEFT(RIGHT(n6.Amount, LEN(n6.Amount)+1 - PATINDEX('%[^0]%', n6.Amount)), LEN(n6.Amount)+1 - PATINDEX('%[^0]%', n6.Amount)-2) + '.' + RIGHT(n6.Amount, 2),
					@LawFirm,
					CASE WHEN @SettlementDate <> '000' THEN RIGHT(LEFT(@SettlementDate, 4), 2) + '/' + RIGHT(@SettlementDate, 2) + '/20' + LEFT(@SettlementDate, 2) ELSE '' END,
					br.BouncedDescription,
					CASE WHEN r.Bounce IS NULL THEN r2.Bounce ELSE r.Bounce END
					FROM tblNOC6 n6
					LEFT JOIN [DMS].[dbo].[tblNACHARegister] nr ON nr.NachaRegisterID = n6.IndividualIDNumber
					LEFT JOIN [DMS].[dbo].[tblNACHARegister2] nr2 ON nr2.NachaRegisterID = n6.IndividualIDNumber
					LEFT JOIN [DMS].[dbo].[tblClient] c ON c.ClientID = nr.ClientID
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

		FETCH NEXT FROM c_Range INTO @DateHolder, @NOC1ID, @LawFirm
		END

		CLOSE c_Range
		DEALLOCATE c_Range

	SELECT * FROM @ReturnedItems ORDER BY SettlementDate, AccountNumber
END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

