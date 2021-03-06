/****** Object:  StoredProcedure [dbo].[stp_GetPersonalStatement]    Script Date: 11/19/2007 15:27:12 ******/
DROP PROCEDURE [dbo].[stp_GetPersonalStatement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[stp_GetPersonalStatement]


as

SELECT
	c.accountnumber,
	CASE c.companyid WHEN '1' then '816' ELSE '801' END [BaseCompany],
	p.firstname + ' ' + p.lastname [Name],
	p.street + ' ' + isnull(p.street2,'') [Street],
	p.city [City],
	s.abbreviation [ST],
	left(p.zipcode,5) [Zip],
	'month range|last' [period], /* period is the previous month i.e. 'From 04/01/2006 to 04/30/2006' */
	DATENAME(month, getdate()) +' '+ CONVERT(VARCHAR, c.depositday) + ', ' + CONVERT(VARCHAR,datepart(year, getdate())) AS  [Dep. Date],
	c.depositamount [Dep. Amt],

	-ISNULL((
		select 
			sum(amount) 
		from 
			tblRegister INNER JOIN
			tblEntryType ON tblRegister.EntryTypeId=tblEntryType.EntryTypeId
		where 
			tblRegister.Clientid=c.ClientId AND
			tblEntryType.Fee=1)
	,0)
	-
	ISNULL((
		select 
			sum(tblregisterpayment.amount) 
		from 
			tblRegisterPayment INNER JOIN
			tblRegister ON tblRegisterPayment.FeeRegisterId=tblRegister.RegisterId		
		where 
			tblRegister.Clientid=c.ClientId)
	,0) as PFOBalance,

	CASE c.depositmethod WHEN 'ACH' THEN 'Y' ELSE 'N' END [ACH],
	CASE c.NoChecks WHEN 1 THEN 'Y' ELSE 'N' END [NoChecks],
	(select 'Payee' = case WHEN accountnumber > 6000000 THEN 'The Seideman Law Firm, P.C.'
		ELSE p.firstname + ' ' + p.lastname+ ' Acct # '+c.accountnumber
		END from tblClient c2 where c2.clientid = c.clientid),
	'P.O. Box 1800' [cslocation1],
	'Rancho Cucamonga, CA 91729-1800' [cslocation2],
	'1-800-914-4832' [desc1],
	'Monday thru Friday 8:00 am to 5:00 pm PST' [desc2]
FROM
	tblClient c
INNER JOIN
	tblPerson p on c.primarypersonid = p.personid 
LEFT JOIN
	tblState s on p.stateid = s.stateid
WHERE
	(SELECT Top 1 ClientStatusId FROM tblRoadmap WHERE tblRoadmap.ClientId=c.ClientId ORDER BY Created DESC, Roadmapid DESC)
		in (10,11,12,14,16)
GO
