--Is there a holday comming up
DECLARE @WeekDayHoliday varchar(50)
DECLARE @MondayHoliday varchar(50)

SET @WeekDayHoliday = (SELECT [Name] FROM tblBankHoliday WHERE date = convert(nvarchar(30), dateadd(day, 1, getdate()), 101))
SET @MondayHoliday = (SELECT [Name] FROM tblBankHoliday WHERE date = convert(nvarchar(30), dateadd(day, 3, getdate()), 101))

IF (SELECT DATENAME(WEEKDAY, @MondayHoliday)) <> 'Monday' AND (SELECT DATENAME(WEEKDAY, getdate())) = 'Friday'
	BEGIN
		SET @MondayHoliday = NULL
	END

IF (SELECT DATENAME(WEEKDAY, @WeekDayHoliday)) NOT IN ('Tuesday', 'Wednesday', 'Thursday', 'Friday')
	BEGIN 
		SET @WeekDayHoliday = NULL
	END 

DECLARE @EndDate smalldatetime

IF @WeekDayHoliday IS NOT NULL
	BEGIN 
		SET @EndDate = (SELECT(CONVERT(nvarchar(30), dateadd(day, 1, getdate()),101)))
	END
IF @MondayHoliday IS NOT NULL
	BEGIN 
		SET @EndDate = (SELECT(convert(nvarchar(30), dateadd(day, 4, getdate()), 101)))
	END  

DECLARE @MultiDep AS TABLE 
(
[Account Number] int,
Bank nvarchar(200),
Attorney nvarchar(200),
[Client Name] nvarchar(250),
[Amount] money,
[Scheduled Deposit Day] int,
[Processed] nvarchar(20),
[Status] nvarchar(20),
[Transaction Type] nvarchar(200),
[AdHoc ACH Day] varchar(50)
)

IF (SELECT DATENAME(WEEKDAY, getdate())) <> 'Friday' AND @WeekDayHoliday IS NULL 
	BEGIN
SELECT 'Tomorrow is, ' + datename(weekday, dateadd(day, 1, getdate())) + ' - ' + CONVERT(nvarchar(30), dateadd(day, 1, getdate()),101) + ' a normal work day.'
SELECT c.AccountNumber, dd.ClientID, dd.DepositDay, dd.DepositMethod, dd.DeletedDate 
FROM tblclientdepositday dd
JOIN tblclient c ON c.clientid = dd.clientid
WHERE dd.depositday = datepart(day, dateadd(day, 1, getdate()))
ORDER BY dd.depositday

INSERT INTO @MultiDep

--Run this every day but Friday and Holidays
SELECT c.accountnumber, 
'Colonial Bank',
co.Name,
p.firstname + ' ' + p.lastname,
nr.Amount * -1,
dd.depositday,
nr.Created,
CASE WHEN nr.idtidbit IS NULL THEN 'Not Sent' ELSE 'OK' END,
CASE WHEN ah.depositdate IS NOT NULL THEN 'Ad Hoc ACH' WHEN dr.depositday IS NOT NULL THEN 'Deposit Rule' ELSE 'Deposit' END,
CASE WHEN ah.DepositDate IS NOT NULL THEN cast(datepart(day, ah.depositdate) AS nvarchar(50)) ELSE 'NA' END
FROM tblnacharegister nr
INNER JOIN tblclient c ON c.clientid = nr.clientid
INNER JOIN tblperson p ON p.clientid = c.clientid
	AND p.relationship = 'Prime'
INNER JOIN tblcompany co on co.companyid = c.companyid
INNER JOIN tblclientdepositday dd ON dd.clientid = nr.clientid
	AND dd.depositday = datepart(day, getdate()) + 1
LEFT JOIN tbladhocach ah ON ah.ClientID = c.clientid
	AND ah.depositdate between (SELECT datepart(day, dateadd(day, -1, GETDATE()))) AND (SELECT datepart(day, dateadd(day, 1, getdate())))
LEFT JOIN tblDepositRuleACH dr ON dr.clientdepositid = dd.clientdepositid
	AND (dr.StartDate <= getdate()
	AND dr.Enddate >= getdate())
WHERE nr.created > dateadd(day, -1, getdate())

UNION 

SELECT c.accountnumber, 
'Ck 21',
co.Name,
p.firstname + ' ' + p.lastname,
nr2.Amount,
dd.depositday,
nr2.Created,
CASE WHEN nr2.status IS NULL THEN 'Not Sent' ELSE 'OK' END,
CASE WHEN ah.depositdate IS NOT NULL THEN 'Ad Hoc ACH' WHEN dr.depositday IS NOT NULL THEN 'Deposit Rule' ELSE 'Deposit' END,
CASE WHEN ah.DepositDate IS NOT NULL THEN cast(datepart(day, ah.depositdate) AS nvarchar(50)) ELSE 'NA' END
FROM tblnacharegister2 nr2
INNER JOIN tblclient c ON c.clientid = nr2.clientid
INNER JOIN tblperson p ON p.clientid = c.clientid
	AND p.relationship = 'Prime'
INNER JOIN tblcompany co on co.companyid = c.companyid
INNER JOIN tblclientdepositday dd ON dd.clientid = nr2.clientid
	AND dd.depositday = datepart(day, getdate()) + 1
LEFT JOIN tbladhocach ah ON ah.ClientID = c.clientid
	AND ah.depositdate between (SELECT datepart(day, dateadd(day, -1, GETDATE()))) AND (SELECT datepart(day, dateadd(day, 1, getdate())))
LEFT JOIN tblDepositRuleACH dr ON dr.clientdepositid = dd.clientdepositid
	AND (dr.StartDate <= getdate()
	AND dr.Enddate >= getdate())
WHERE nr2.created > dateadd(day, -1, getdate())
END

IF (SELECT DATENAME(WEEKDAY, getdate())) = 'Friday' AND @MondayHoliday IS NULL 
	BEGIN
SELECT 'Tomorrow is, ' + datename(weekday, dateadd(day, 1, getdate())) + ' - ' + CONVERT(nvarchar(30), dateadd(day, 1, getdate()),101) + '  with no holiday on Monday.'
SELECT c.AccountNumber, dd.ClientID, dd.DepositDay, dd.DepositMethod, dd.DeletedDate 
FROM tblclientdepositday dd
JOIN tblclient c ON c.clientid = dd.clientid
WHERE dd.depositday between datepart(day, dateadd(day, 1, getdate())) AND datepart(day, dateadd(day, 4, getdate()))
ORDER BY dd.depositday

INSERT INTO @MultiDep

--Run this on Friday with no Monday holiday
SELECT 
c.accountnumber, 
'Colonial Bank',
co.Name,
p.firstname + ' ' + p.lastname,
nr.Amount * -1,
dd.depositday,
nr.Created,
CASE WHEN nr.idtidbit IS NULL THEN 'Not Sent' ELSE 'OK' END,
CASE WHEN ah.depositdate IS NOT NULL THEN 'Ad Hoc ACH' WHEN dr.depositday IS NOT NULL THEN 'Deposit Rule' ELSE 'Deposit' END,
CASE WHEN ah.DepositDate IS NOT NULL THEN cast(datepart(day, ah.depositdate) AS nvarchar(50)) ELSE 'NA' END
FROM tblnacharegister nr
INNER JOIN tblclient c ON c.clientid = nr.clientid
INNER JOIN tblperson p ON p.clientid = c.clientid
	AND p.relationship = 'Prime'
INNER JOIN tblcompany co on co.companyid = c.companyid
INNER JOIN tblclientdepositday dd ON dd.clientid = nr.clientid
	AND dd.depositday between datepart(day, getdate()) + 1 AND datepart(day, getdate()) + 3
LEFT JOIN tbladhocach ah ON ah.ClientID = c.clientid
	AND ah.depositdate between (SELECT datepart(day, dateadd(day, -1, GETDATE()))) AND (SELECT datepart(day, dateadd(day, 3, getdate())))
LEFT JOIN tblDepositRuleACH dr ON dr.clientdepositid = dd.clientdepositid
	AND (dr.StartDate <= getdate()
	AND dr.Enddate >= getdate())
WHERE nr.created > dateadd(day, -1, getdate())

UNION 

SELECT 
c.accountnumber, 
'Ck 21',
co.Name,
p.firstname + ' ' + p.lastname,
nr2.Amount,
dd.depositday,
nr2.Created,
CASE WHEN nr2.status IS NULL THEN 'Not Sent' ELSE 'OK' END,
CASE WHEN ah.depositdate IS NOT NULL THEN 'Ad Hoc ACH' WHEN dr.depositday IS NOT NULL THEN 'Deposit Rule' ELSE 'Deposit' END,
CASE WHEN ah.DepositDate IS NOT NULL THEN cast(datepart(day, ah.depositdate) AS nvarchar(50)) ELSE 'NA' END
FROM tblnacharegister2 nr2
INNER JOIN tblclient c ON c.clientid = nr2.clientid
INNER JOIN tblperson p ON p.clientid = c.clientid
	AND p.relationship = 'Prime'
INNER JOIN tblcompany co on co.companyid = c.companyid
INNER JOIN tblclientdepositday dd ON dd.clientid = nr2.clientid
	AND dd.depositday between datepart(day, getdate()) + 1 AND datepart(day, getdate()) + 3
LEFT JOIN tbladhocach ah ON ah.ClientID = c.clientid
	AND ah.depositdate between (SELECT datepart(day, dateadd(day, -1, GETDATE()))) AND (SELECT datepart(day, dateadd(day, 3, getdate())))
LEFT JOIN tblDepositRuleACH dr ON dr.clientdepositid = dd.clientdepositid
	AND (dr.StartDate <= getdate()
	AND dr.Enddate >= getdate())
WHERE nr2.created > dateadd(day, -1, getdate())
END

SELECT * FROM @multidep