IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Insert_CorrectRtrFeeAdjustment')
	BEGIN
		DROP  PROCEDURE  stp_Insert_CorrectRtrFeeAdjustment
	END

GO

CREATE PROCEDURE stp_Insert_CorrectRtrFeeAdjustment
	(
		@AccountNumber NVARCHAR(50)
	)

AS

DECLARE @clientid INT
DECLARE @adjustedregisterid INT
DECLARE @amount MONEY
DECLARE @FeePct MONEY

SET @clientid = (SELECT clientid FROM tblclient WHERE accountnumber = @AccountNumber)
SET @FeePct = (SELECT [tblClient].[SetupFeePercentage] FROM [tblClient] WHERE [tblClient].[ClientID] = @ClientID)
IF @FeePct = 0.10 BEGIN SET @FeePct = 0.08 END

DECLARE @vtblAdjustments TABLE
(
	RetainerID INT,
	RetainerAdjustment MONEY
)

INSERT INTO
	@vtblAdjustments
SELECT
	RetainerID,
	RetainerAdjustment
FROM
	(
		SELECT
			(SELECT registerid FROM tblregister WHERE accountid = a.accountid AND entrytypeid = 2 AND void IS NULL) AS RetainerID,
			(-originalamount * @FeePct) - (SELECT amount FROM tblregister WHERE accountid = a.accountid AND entrytypeid = 2 AND void IS NULL) AS RetainerAdjustment
		FROM 
			tblaccount AS a
		WHERE
			clientid = @clientid

		UNION ALL

		SELECT
			(SELECT registerid FROM tblregister WHERE accountid = a.accountid AND entrytypeid = 42 AND void IS NULL) AS RetainerID,
			(-originalamount * 0.02) - (SELECT amount FROM tblregister WHERE accountid = a.accountid AND entrytypeid = 42 AND void IS NULL) AS RetainerAdjustment
		FROM 
			tblaccount AS a
		WHERE
			clientid = @clientid
	) AS derived
WHERE
	NOT RetainerAdjustment = 0
	AND RetainerID IS NOT NULL

DECLARE cursor_fix CURSOR FOR
	SELECT
		RetainerID,
		RetainerAdjustment
	FROM
		@vtblAdjustments
	WHERE
		ABS(RetainerAdjustment) > 0.1

OPEN cursor_fix

FETCH NEXT FROM cursor_fix INTO @adjustedregisterid, @amount

WHILE @@fetch_status = 0
BEGIN
	INSERT INTO tblregister (ClientId, TransactionDate, Amount, Balance, EntryTypeId, IsFullyPaid, Created, CreatedBy, AdjustedRegisterID, PFOBalance, SDABalance) VALUES (@clientid, GETDATE(), @amount,	0,	 -2,	0, GETDATE(), 531, @adjustedregisterid, 0.00, 0.00)

	EXEC stp_DoRegisterUpdateFeeAmount @adjustedregisterid

	FETCH NEXT FROM cursor_fix INTO @adjustedregisterid, @amount
END

CLOSE cursor_fix
DEALLOCATE cursor_fix

EXEC stp_doregisterrebalanceclient @clientid

GO

GRANT EXEC ON stp_Insert_CorrectRtrFeeAdjustment TO PUBLIC

GO

