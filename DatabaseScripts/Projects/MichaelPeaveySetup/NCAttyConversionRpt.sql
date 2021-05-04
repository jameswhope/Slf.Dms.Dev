DECLARE @TransDate smalldatetime
SET @TransDate = '04/01/2009'

SELECT c.ClientID [Client ID], 
c.accountnumber [Account Number], 
p.firstname + ' ' + p.LastName [Client Name],
CASE WHEN p.stateid = 34 THEN 'North Carolina' ELSE '' END [State],
CASE WHEN dd.DepositDay IS NULL THEN c.depositday ELSE dd.depositday END [Deposit Day],
CASE WHEN dd.DepositMethod IS NULL THEN c.depositmethod ELSE dd.depositmethod END [Deposit Method],
CASE WHEN dd.depositAmount IS NULL THEN r.amount ELSE dd.DepositAmount END [Planned Deposit Amount],
r.amount [Last Deposit Amount],
r.TransactionDate [Transaction Date],
r.bounce [Bounced],
r.void [Voided],
dd.created [Conversion date],
c.PFOBalance [PFO Balance],
c.SDABalance [SDA Balance],
CASE WHEN dd.depositmethod IS NULL THEN 'No' ELSE 'Yes' END [Converted to MultiDeposit],
u.FirstName + ' ' + u.LastName [Converted By],
CASE WHEN c.companyid > 4 THEN 'Yes' ELSE 'No' END [Attorney Changed] 
FROM tblclient c
INNER JOIN tblperson p ON p.clientid = c.ClientID
	AND p.relationship = 'Prime'
LEFT JOIN tblregister r ON r.clientid = c.ClientID
LEFT JOIN tblClientDepositDay dd ON dd.clientid = c.clientid
LEFT JOIN tblUser u ON u.UserID = dd.createdby
WHERE c.companyid = 2
AND p.StateID = 34
AND c.CurrentClientStatusID NOT IN (15, 17, 18)
AND r.entrytypeid = 3
AND r.bounce IS NULL 
AND r.transactiondate >= @TransDate
ORDER BY c.accountnumber



