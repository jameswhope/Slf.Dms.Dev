IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetDailyNegativeBal')
	BEGIN
		DROP  Procedure  stp_GetDailyNegativeBal
	END

GO

CREATE PROCEDURE [dbo].[stp_GetDailyNegativeBal] 
AS
BEGIN
	SET NOCOUNT ON;

DECLARE @commrecid INT
DECLARE @coName VARCHAR(150)
DECLARE @Amount MONEY
DECLARE @AccountNumber VARCHAR(100)

DECLARE @vtblComms TABLE
(
      CompanyID INT,
      TrustID INT,
      ID INT,
      [Type] VARCHAR(14),
      CommScenID INT,
      CommRecID INT,
      ParentCommRecID INT,
      [Order] INT,
      Amount MONEY
)

INSERT INTO
      @vtblComms
SELECT
      CompanyID,
      TrustID,
      ID,
      [Type],
      CommScenID,
      CommRecID,
      ParentCommRecID,
      [Order],
      Amount
FROM
(
      SELECT
            cs.CompanyID,
            case when v.converted is null then c.TrustID
                  when v.converted > rp.paymentdate then v.OrigTrustID
                  else c.TrustID 
            end [TrustID],
            cp.CommPayID as ID,
            'CommPay' as [Type],
            cs.CommScenID,
            cs.CommRecID,
            cs.ParentCommRecID,
            cs.[Order],
            cp.Amount
      FROM
            tblCommPay as cp
            inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cp.RegisterPaymentID
            inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
            inner join tblClient as c on c.ClientID = r.ClientID
            inner join tblCommStruct as cs on cs.CommStructID = cp.CommStructID
            left join vw_ClientTrustConvDate v on v.clientid = c.clientid
      WHERE
            cp.CommBatchID is null

      UNION ALL

      SELECT
            cs.CompanyID,
            case when v.converted is null then c.TrustID
                  when v.converted > rp.paymentdate then v.OrigTrustID
                  else c.TrustID 
            end [TrustID],
            cc.CommChargebackID as ID,
            'CommChargeback' as [Type],
            cs.CommScenID,
            cs.CommRecID,
            cs.ParentCommRecID,
            cs.[Order],
            -cc.Amount
      FROM
            tblCommChargeback as cc
            inner join tblRegisterPayment as rp on rp.RegisterPaymentID = cc.RegisterPaymentID
            inner join tblRegister as r on r.RegisterID = rp.FeeRegisterID
            inner join tblClient as c on c.ClientID = r.ClientID
            inner join tblCommStruct as cs on cs.CommStructID = cc.CommStructID
            left join vw_ClientTrustConvDate v on v.clientid = c.clientid
      WHERE
            cc.CommBatchID is null
) as drvComms

CREATE TABLE #tblNegativeBal
(
CommRecID INT,
Agency VARCHAR(150),
Balance MONEY,
AccountNumber VARCHAR(50)
)

INSERT INTO #tblNegativeBal

SELECT
      v.CommRecID,
	  cr.display,
      SUM(v.Amount) AS Amount,
	  cr.accountnumber
FROM
      @vtblComms v
	  JOIN tblCommRec cr ON cr.CommRecID = v.commrecid
--WHERE cr.CommRecTypeID > 1
GROUP BY
	  cr.display,
      v.CommRecID,
	  cr.accountnumber
HAVING SUM(v.amount) < 0

--SELECT * from #tblNegativeBal where AccountNumber IS not null

-- Add like accountnumbers balances to represent 
-- one agency if there are multiple commrecs for the same agency
DECLARE c_neg CURSOR FOR
SELECT * FROM #tblNegativeBal ORDER BY commrecid
OPEN c_neg

FETCH NEXT FROM c_neg INTO @commrecid, @coName, @Amount, @AccountNumber
WHILE @@FETCH_STATUS = 0
BEGIN
			UPDATE #tblNegativeBal SET Balance = Balance + @Amount
			WHERE accountnumber = @accountnumber AND commrecid <> @Commrecid
			DELETE FROM #tblNegativeBal WHERE AccountNumber = @Accountnumber AND commrecid > @CommrecID
	FETCH NEXT FROM c_neg INTO @commrecid, @coName, @Amount, @AccountNumber
END

CLOSE c_neg
DEALLOCATE c_neg

SELECT * FROM #tblNegativeBal  
WHERE AccountNumber IS NOT NULL
ORDER BY Agency

DROP TABLE #tblNegativeBal
END
GO

