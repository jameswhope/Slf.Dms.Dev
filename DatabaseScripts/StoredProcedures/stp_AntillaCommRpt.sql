/****** Object:  StoredProcedure [dbo].[stp_AntillaCommRpt]    Script Date: 11/19/2007 15:26:53 ******/
DROP PROCEDURE [dbo].[stp_AntillaCommRpt]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Christopher Nott
-- Create date: Sept 5, 2007
-- Description:	Antilla Comm Report
-- =============================================
CREATE PROCEDURE [dbo].[stp_AntillaCommRpt] 
	
	@startdate datetime = null,
	@enddate datetime = null
	 
AS
BEGIN

IF (@startdate is null) and (@enddate is null) 
BEGIN
SET @startdate = dateadd(m, datediff(m, 0, dateadd(m, -1, getdate())), 0)
SET @enddate= dateadd(m, datediff(m, 0, getdate()),0) 
END

SET NOCOUNT ON;

DECLARE @MFComm TABLE(
	agency varchar(50),
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
) SELECT	a.code,
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
WHERE	c1.agencyid in (839,842,843,844 ) and
		c1.currentclientstatusid not in (15,17,18) and
		c1.accountnumber is not null 

UPDATE @MFComm 
	SET AgntDue = ROUND(paid * rate,0)


SELECT * FROM @MFComm ORDER BY hiredate

END
GO
