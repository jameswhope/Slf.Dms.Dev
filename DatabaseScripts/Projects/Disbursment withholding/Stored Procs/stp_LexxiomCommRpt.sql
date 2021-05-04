IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_LexxiomCommRpt')
	BEGIN
		DROP  Procedure  stp_LexxiomCommRpt
	END

GO

-- =============================================
-- Author:		Christopher Nott
-- Create date: Sept 5, 2007
-- Description:	Antilla Comm Report
-- Modified  by Jim Hope 8/22/2011 for selecting which agencies get paid by Lexxiom
-- =============================================
CREATE PROCEDURE [dbo].[stp_LexxiomCommRpt] 
	
	@startdate datetime = null,
	@enddate datetime = null
	 
AS
BEGIN

--DECLARE @StartDate datetime
--DECLARE @EndDate datetime

--IF (@startdate is null) and (@enddate is null) 
--BEGIN
--SET @startdate = dateadd(m, datediff(m, 0, dateadd(m, -1, getdate())), 0)
--SET @enddate= dateadd(m, datediff(m, 0, getdate()),0) 
--END

--Setup the dates for processing
IF @StartDate IS NULL
	BEGIN
		SET @StartDate = CAST(CAST(GETDATE() AS VARCHAR(12)) + ' 12:00:01 AM' AS DATETIME)
	END
SET @EndDate = @StartDate + ' 11:59:59 PM'

SET NOCOUNT ON;

DECLARE @MFComm TABLE(
	agency varchar(150),
	hiredate datetime,
	acctno int,
	cname varchar(255),
	feeAmt money,
	paid money,
	rate money,
	AgntDue money
)

INSERT INTO @MFComm(
	agency,
	hiredate,
	acctno,
	cname,
	feeAmt,
	paid,
	rate
) SELECT	a.Name, --08.22.11 jhope
		convert(varchar, c1.created, 110),
		c1.accountnumber,
		p.firstname + ' ' + p.lastname as [Name],
		c1.MonthlyFee,
		paid = (
			SELECT	isnull(sum(rp.amount),0)
			FROM	tblRegisterPayment rp INNER JOIN 
					tblRegister r ON rp.feeregisterid = r.registerid
			WHERE	r.clientid = c1.clientid AND
					r.entrytypeid = 1 AND
					rp.paymentdate >= @startdate AND
					rp.paymentdate <= @enddate AND
					(rp.bounced < 1 and rp.voided <1)
		),
		rate = CASE 
					WHEN c1.MonthlyFee =  55 then .0909
					When c1.MonthlyFee =  65 then .0749
					ELSE 0 
					END
FROM	tblClient c1 INNER JOIN
		tblPerson p ON c1.primarypersonid = p.personid INNER JOIN
		tblagency a ON c1.agencyid = a.agencyid
--12.1.08.ug
--added agencyid 838 to match commission changes
WHERE	c1.agencyid in (838,839,842,843,844) and
--12.1.08.ug
--c1.currentclientstatusid not in (15,17,18) and
		c1.accountnumber is not null 

UPDATE @MFComm 
	SET AgntDue = ROUND(paid * rate,0)

--SELECT * FROM @MFComm ORDER BY hiredate

--08.22.11 jhope
SELECT '      **** Lexxiom - Antilla' + Agency [Agency], sum(agntdue) [CommDue] from @mfcomm group BY agency

--SELECT sum(agntdue) from @mfcomm

END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

