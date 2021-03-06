/****** Object:  StoredProcedure [dbo].[stp_GlobalCommission]    Script Date: 11/19/2007 15:27:20 ******/
DROP PROCEDURE [dbo].[stp_GlobalCommission]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_GlobalCommission]
(
	@startdate datetime,
	@enddate datetime
)

AS

if @startdate is null
begin
	set @startdate = dateadd(day, 10, dateadd(day, -day(getdate()), dateadd(month, -1, getdate())))
end

if @enddate is null
begin
	set @enddate = dateadd(month, 1, @startdate)
end

declare @vtblGlobalCommission table
(
	RetFee money,
	RetFeeRev money,
	RetFeeNet money,
	SettFee money,
	SettFeeRev money,
	SettFeeNet money,
	TotalCommission money
)


-- RetFee --

CREATE TABLE #globalComm (
	clientid int,
	AcctNo int,
	clientName nvarchar(255),
	start datetime,
	RetFees decimal(18,2),
	BegBal decimal(18,2),
	NewTrans decimal(18,2),
	EndBal decimal(18,2),
	PayRate decimal(18,2),
	repComm decimal(18,2),
	agencyid int,
	status int
)

INSERT INTO #globalComm(	
	clientid,
	AcctNo,
	ClientName,
	start,
	agencyid,
	[status]
)
SELECT	c.clientid,
	c.accountnumber,
	p.firstname + ' '+ p.lastname,
	c.created,
	c.agencyid,
	c.currentclientstatusid
FROM tblClient c
INNER JOIN tblPerson p ON c.primarypersonid = p.personid

UPDATE #globalComm 
SET 
	RetFees = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 2 AND r.clientid = #globalComm.clientid AND (bounce is null and void is null)),0),
	
	BegBal = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 2 AND r.clientid = #globalComm.clientid AND (bounce is null and void is null)),0) -  -- retainer fees assessed
	isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm.clientid AND R.ENTRYTYPEID = 2 and not (bounced =1 or voided =1) and rp.paymentdate < @startdate),0), -- retainer payments
	
	NewTrans = ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm.clientid AND R.ENTRYTYPEID = 2 and not (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0),

	EndBal =
		(isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 2 AND r.clientid = #globalComm.clientid AND (bounce is null and void is null)),0) 
			- isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm.clientid AND R.ENTRYTYPEID = 2 and not (bounced =1 or voided =1) and rp.paymentdate < @startdate),0))
				- (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm.clientid AND R.ENTRYTYPEID = 2 and not (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)),
	PayRate = .5,
	repComm = (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm.clientid AND R.ENTRYTYPEID = 2 and not (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)) * .5

INSERT INTO
@vtblGlobalCommission (RetFee)
SELECT isnull(sum(repcomm), 0)
FROM	#globalComm 
WHERE 	agencyid = 812 
AND NOT	status IN (15,17,18)
AND NewTrans > 0

DROP TABLE #globalComm


-- RetFeeRev --

CREATE TABLE #globalRetComm (
	clientid int,
	AcctNo int,
	clientName nvarchar(255),
	start datetime,
	RetFees decimal(18,2),
	BegBal decimal(18,2),
	NewTrans decimal(18,2),
	EndBal decimal(18,2),
	PayRate decimal(18,2),
	repComm decimal(18,2),
	agencyid int,
	status int
)

INSERT INTO #globalRetComm(	
	clientid,
	AcctNo,
	ClientName,
	start,
	agencyid,
	status
)
SELECT	c.clientid,
	c.accountnumber,
	p.firstname + ' '+ p.lastname,
	c.created,
	c.agencyid,
	c.currentclientstatusid
FROM tblClient c
INNER JOIN tblPerson p ON c.primarypersonid = p.personid

UPDATE #globalRetComm 
SET 
	 RetFees = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 2 AND r.clientid = #globalRetComm.clientid AND not (bounce is null or void is null)),0),
	
	 BegBal = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 2 AND r.clientid = #globalRetComm.clientid AND not (bounce is null or void is null)),0) -  -- retainer fees assessed
	 isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm.clientid AND R.entrytypeid = 2 and (bounced =1 or voided =1) and rp.paymentdate < @startdate),0), -- retainer payments
	
	NewTrans = (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm.clientid AND R.entrytypeid = 2 and (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0))*-1,

	 EndBal =
		(isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 2 AND r.clientid = #globalRetComm.clientid AND not (bounce is null or void is null)),0) 
			- isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm.clientid AND R.entrytypeid = 2 and (bounced =1 or voided =1) and rp.paymentdate < @startdate),0))
				- (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm.clientid AND R.entrytypeid = 2 and (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)),
	PayRate = .50,
	repComm = ((ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm.clientid AND R.entrytypeid = 2 and (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0))*-1) * .50

UPDATE
@vtblGlobalCommission
SET RetFeeRev =
(SELECT	isnull(sum(repComm), 0)
FROM	#globalRetComm 
WHERE 	agencyid = 812 
AND NOT	status IN (15,17,18)
AND NewTrans <> 0)

DROP TABLE #globalRetComm


-- SettFee

CREATE TABLE #globalComm2 (
	clientid int,
	AcctNo int,
	clientName nvarchar(255),
	start datetime,
	RetFees decimal(18,2),
	BegBal decimal(18,2),
	NewTrans decimal(18,2),
	EndBal decimal(18,2),
	PayRate decimal(18,2),
	repComm decimal(18,2),
	agencyid int,
	status int
)

INSERT INTO #globalComm2(	
	clientid,
	AcctNo,
	ClientName,
	start,
	agencyid,
	status
)
SELECT	c.clientid,
	c.accountnumber,
	p.firstname + ' '+ p.lastname,
	c.created,
	c.agencyid,
	c.currentclientstatusid
FROM tblClient c
INNER JOIN tblPerson p ON c.primarypersonid = p.personid

UPDATE #globalComm2 
SET 
	RetFees = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 4 AND r.clientid = #globalComm2.clientid AND (bounce is null and void is null)),0),
	
	BegBal = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 4 AND r.clientid = #globalComm2.clientid AND (bounce is null and void is null)),0) -  -- retainer fees assessed
	isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm2.clientid AND R.entrytypeid = 4 and not (bounced =1 or voided =1) and rp.paymentdate < @startdate),0), -- retainer payments
	
	NewTrans = ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm2.clientid AND R.entrytypeid = 4 and not (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0),

	EndBal =
		(isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 4 AND r.clientid = #globalComm2.clientid AND (bounce is null and void is null)),0) 
			- isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm2.clientid AND R.entrytypeid = 4 and not (bounced =1 or voided =1) and rp.paymentdate < @startdate),0))
				- (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm2.clientid AND R.entrytypeid = 4 and not (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)),
	PayRate = .25,
	repComm = (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalComm2.clientid AND R.entrytypeid = 4 and not (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)) * .5

UPDATE
@vtblGlobalCommission
SET SettFee =
(SELECT	isnull(sum(repComm), 0)
FROM	#globalComm2 
WHERE 	agencyid = 812 
AND NOT	status IN (15,17,18)
AND NewTrans > 0)

DROP TABLE #globalComm2


-- SettFeeRev --

CREATE TABLE #globalRetComm2 (
	clientid int,
	AcctNo int,
	clientName nvarchar(255),
	start datetime,
	RetFees decimal(18,2),
	BegBal decimal(18,2),
	NewTrans decimal(18,2),
	EndBal decimal(18,2),
	PayRate decimal(18,2),
	repComm decimal(18,2),
	agencyid int,
	status int
)

INSERT INTO #globalRetComm2(	
	clientid,
	AcctNo,
	ClientName,
	start,
	agencyid,
	status
)
SELECT	c.clientid,
	c.accountnumber,
	p.firstname + ' '+ p.lastname,
	c.created,
	c.agencyid,
	c.currentclientstatusid
FROM tblClient c
INNER JOIN tblPerson p ON c.primarypersonid = p.personid

UPDATE #globalRetComm2 
SET 
	 RetFees = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 4AND r.clientid = #globalRetComm2.clientid AND not (bounce is null or void is null)),0),
	
	 BegBal = isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 4AND r.clientid = #globalRetComm2.clientid AND not (bounce is null or void is null)),0) -  -- retainer fees assessed
	 isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm2.clientid AND R.entrytypeid = 4and (bounced =1 or voided =1) and rp.paymentdate < @startdate),0), -- retainer payments
	
	NewTrans = (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm2.clientid AND R.entrytypeid = 4and (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)*-1),

	 EndBal =
		(isnull((SELECT (SUM(amount)*-1) FROM tblRegister r WHERE entrytypeid = 4AND r.clientid = #globalRetComm2.clientid AND not (bounce is null or void is null)),0) 
			- isnull((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm2.clientid AND R.entrytypeid = 4and (bounced =1 or voided =1) and rp.paymentdate < @startdate),0))
				- (ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm2.clientid AND R.entrytypeid = 4and (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0)),
	PayRate = .25,
	repComm = ((ISNULL((SELECT SUM(RP.amount) FROM TBLREGISTERPAYMENT RP INNER JOIN TBLREGISTER R ON RP.FEEREGISTERID = R.REGISTERID WHERE R.CLIENTID = #globalRetComm2.clientid AND R.entrytypeid = 4and (bounced =1 or voided =1) and rp.paymentdate >= @startdate and rp.PaymentDate < @enddate),0))*-1) * .25

UPDATE
@vtblGlobalCommission
SET SettFeeRev =
(SELECT	isnull(sum(repComm), 0)
FROM	#globalRetComm2 
WHERE 	agencyid = 812 
AND NOT	status IN (15,17,18)
AND NewTrans <> 0)

DROP TABLE #globalRetComm2


-- RetFeeNet --

UPDATE
	@vtblGlobalCommission
SET
	RetFeeNet = (SELECT RetFee + RetFeeRev FROM @vtblGlobalCommission)


-- SettFeeNet --

UPDATE
	@vtblGlobalCommission
SET
	SettFeeNet = (SELECT SettFee + SettFeeRev FROM @vtblGlobalCommission)


-- TotalCommission --

UPDATE
	@vtblGlobalCommission
SET
	TotalCommission = (SELECT RetFeeNet + SettFeeNet FROM @vtblGlobalCommission)


-- Return --

SELECT
	*
FROM
	@vtblGlobalCommission
GO
