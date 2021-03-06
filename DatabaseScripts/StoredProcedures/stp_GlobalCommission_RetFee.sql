/****** Object:  StoredProcedure [dbo].[stp_GlobalCommission_RetFee]    Script Date: 11/19/2007 15:27:20 ******/
DROP PROCEDURE [dbo].[stp_GlobalCommission_RetFee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_GlobalCommission_RetFee]
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

SELECT	AcctNo,
		ClientName,
		convert(nvarchar,start,110) as [Start Date],
		NewTrans,
		PayRate,
		repComm
FROM	#globalComm 
WHERE 	agencyid = 812 
AND NOT	status IN (15,17,18)
AND NewTrans > 0
ORDER BY AcctNo

DROP TABLE #globalComm
GO
