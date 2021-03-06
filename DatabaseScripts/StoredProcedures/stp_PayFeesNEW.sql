/****** Object:  StoredProcedure [dbo].[stp_PayFeesNEW]    Script Date: 11/19/2007 15:27:28 ******/
DROP PROCEDURE [dbo].[stp_PayFeesNEW]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_PayFeesNEW]
(
	@hidemessages BIT = 1
)

AS

SET NOCOUNT ON
SET ANSI_WARNINGS OFF

---------------------------------------------------------------------------------------------------
-- LOGIC FOR ALL FEE COLLECTION:
-- (1) Grab all fees to be paid in the system.  Fees to be paid are:
--        (a) Must be negative (less than zero) amount
--        (b) Entry type must be marked as actual fee (fee=1)
--        (c) Cannot be marked as fully paid
--        (d) Cannot be marked as VOID
--        (e) Cannot be marked as BOUNCE
-- (2) Fees must be paid in order shown by client first, then entry
--      type, then transaction date.  This is important to remember
--      when returning the list of fees to be paid in step 1
---------------------------------------------------------------------------------------------------


-- discretionary variables
DECLARE @registerid INT
DECLARE @CompanyID INT
DECLARE @marker DATETIME
DECLARE @total INT
DECLARE @finished INT
DECLARE @percent MONEY
DECLARE @num INT
DECLARE @sum MONEY

DECLARE @vtbPayFees TABLE
(
	RegisterID INT,
	ClientID INT 
)

--Populate a payfees audit and start point in tblPayFees.
INSERT INTO tblPayFees
SELECT tblregister.registerid,
	   tblRegister.ClientId,
	   0,
	   CONVERT(VARCHAR(10), GETDATE(), 101)
FROM tblregister 
INNER JOIN tblentrytype ON tblregister.entrytypeid = tblentrytype.entrytypeid
INNER JOIN tblClient ON tblRegister.ClientID = tblClient.ClientID
WHERE tblClient.CurrentClientStatusID NOT IN (17,18)
AND tblentrytype.fee = 1
AND tblregister.amount < 0 
AND tblregister.isfullypaid = 0 
AND tblregister.void is null 
AND tblregister.bounce is null

--Load unprocessed register id's into variable table.

INSERT INTO @vtbPayFees
SELECT RegisterID,
	   ClientID
FROM tblPayFees 
WHERE FeeDate = CONVERT(VARCHAR(10), GETDATE(), 101)
AND Processed = 0

-- Set the total count of fees to process

SELECT @total = COUNT(RegisterID)
FROM @vtbPayFees

SET @marker = GETDATE()
SET @finished = 0
SET @percent = 0

PRINT '(' + CONVERT(VARCHAR(50), GETDATE(), 13) + ') Analyzing ' + CONVERT(VARCHAR(50), @total) + ' fees for possible payment collection...'

-- (1) open and loop all oustanding fees
DECLARE cursor_a CURSOR LOCAL FAST_FORWARD FOR
	SELECT RegisterID, 
		   ClientID
	FROM @vtbPayFees

OPEN cursor_a

FETCH NEXT FROM cursor_a INTO @registerid, 
							  @CompanyID
WHILE @@FETCH_STATUS = 0
	BEGIN 
		-- (2) run payment proc on each fee
		EXEC stp_payfee @registerid, @hidemessages

		-- progress display
		SET @finished = @finished + 1

		IF ((CONVERT(MONEY, @finished) / CONVERT(MONEY, @total)) * CONVERT(MONEY, 100)) > (@percent + 1)
			BEGIN
				SET @percent = ((CONVERT(MONEY, @finished) / CONVERT(MONEY, @total)) * CONVERT(MONEY, 100))
				SELECT @num = ISNULL(COUNT(*), 0),
					   @sum = ISNULL(SUM(amount), 0)
				FROM tblregisterpayment
				WHERE paymentdate >= @marker
				
				IF (@CompanyID = 2)
					BEGIN
						PRINT ('PALMER CLIENT BELOW')
					END
				ELSE
					BEGIN
						PRINT ('SEIDEMAN CLIENT BELOW')
					END				

				PRINT '(' + CONVERT(VARCHAR(50), GETDATE(), 13) + ') Processed ' + CONVERT(VARCHAR(50), @finished) 
					+ ' fees (' + CONVERT(VARCHAR(50), @percent) + '%) and collected ' 
					+ CONVERT(VARCHAR(50), @num) + ' payments totalling $' + CONVERT(VARCHAR(50), @sum)
			END
		UPDATE tblPayFees
		SET Processed = 1
		WHERE RegisterID = @registerid
		AND FeeDate = CONVERT(VARCHAR(10), GETDATE(), 101)		

		FETCH NEXT FROM cursor_a INTO @registerid, @CompanyID

	END

CLOSE cursor_a
DEALLOCATE cursor_a

SET NOCOUNT OFF
SET ANSI_WARNINGS ON
GO
