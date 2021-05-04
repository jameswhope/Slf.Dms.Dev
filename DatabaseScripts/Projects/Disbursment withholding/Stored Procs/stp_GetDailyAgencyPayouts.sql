IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetDailyAgencyPayouts')
	BEGIN
		DROP  Procedure  stp_GetDailyAgencyPayouts
	END

GO

-- =============================================
-- Author:		Jim Hope
-- Create date: 07/01/2011
-- Description:	Get today's Payouts to Agencies
-- Modified per JHernandez 08/02/2011
-- =============================================
-- =============================================
-- Author:		Jim Hope
-- Create date: 07/01/2011
-- Description:	Get today's Payouts to Agencies
-- Modified per JHernandez 08/02/2011
-- =============================================
CREATE PROCEDURE [dbo].[stp_GetDailyAgencyPayouts] 
	@sDate datetime =  NULL
AS
BEGIN
	SET NOCOUNT ON;
--Testing*******************************
--DECLARE @sDate datetime
--**************************************
--Aggregated total disbursments by bank account numbers

DECLARE @coName as varchar(150)
DECLARE @Amount as varchar(50)
DECLARE @AccountNumber as varchar(50)


declare @vtblComms table
(
      CompanyID int,
      TrustID int,
      ID int,
      [Type] varchar(14),
      CommScenID int,
      CommRecID int,
      ParentCommRecID int,
      [Order] int,
      Amount money
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

create table #tblPayee
(
[Payee] varchar(150),
[ARBalance] money,
[Payout] money,
[AccountNumber] varchar(50),
[NewBalance] money
)

INSERT INTO #tblPayee

SELECT
	  cr.display,
      SUM(v.Amount),
      '0.00',
	  cr.accountnumber,
	  '0.00'
FROM
      @vtblComms v
	  JOIN tblCommRec cr ON cr.CommRecID = v.commrecid
WHERE AccountNumber IS NOT NULL
GROUP BY
	  cr.display,
	  cr.accountnumber
HAVING SUM(v.amount) < 0
     
DECLARE c_Payee cursor for
select name, sum(amount) [Amount], AccountNumber
from (
	select name, amount, AccountNumber 
	from tblnacharegister2
	where nachafileid = -1
	and commrecid > 0

	union all

	select name, amount, accountnumber  
	from tblnacharegister
	where nachafileid is null
	and commrecid in (20,11)
	and amount > 0
) d
group by name, accountnumber
order by name

OPEN c_Payee

FETCH NEXT FROM c_Payee INTO @coName, @Amount, @AccountNumber
WHILE @@FETCH_STATUS = 0
BEGIN
			print @Amount
			UPDATE #tblPayee SET Payout = @Amount
			WHERE accountnumber = @accountnumber
	FETCH NEXT FROM c_Payee INTO @coName, @Amount, @AccountNumber
END

CLOSE c_Payee
DEALLOCATE c_Payee
      
      
SELECT * FROM #tblPayee WHERE Payee NOT like '%General Clearing%' ORDER BY Payee
      
DROP TABLE #tblPayee

END
GO

