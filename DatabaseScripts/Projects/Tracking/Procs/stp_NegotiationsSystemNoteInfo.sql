IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsSystemNoteInfo')
	BEGIN
		DROP  Procedure  stp_NegotiationsSystemNoteInfo
	END

GO

CREATE Procedure stp_NegotiationsSystemNoteInfo
(
	@accountID numeric
)
as
SELECT     TOP (1) 
	currcred.CreditorID AS CurrCreditorID, 
	ISNULL(origcred.Name, currcred.Name) AS OriginalCreditorName, 
	currcred.Name AS CurrentCreditorName, 
	RIGHT(ci.AccountNumber, 4) AS CreditorAcctLast4, CASE WHEN ct.firstname IS NULL AND ct.lastname IS NULL THEN '(No Contact information on file)' ELSE isnull(ct.firstname, '') + ' ' + isnull(ct.lastname, '') END AS CreditorContact, 
	ISNULL('(' + p.AreaCode + ')' + LEFT(p.Number, 3) + '-' + RIGHT(p.Number, 4) + CASE WHEN NOT extension IS NULL THEN ' x' + CAST(extension AS varchar) ELSE '' END, '(No Contact information on file)') AS ContactPhone
FROM tblAccount AS a with(nolock) INNER JOIN
	tblCreditorInstance AS ci with(nolock) ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
	tblCreditor AS currcred with(nolock) ON currcred.CreditorID = ci.CreditorID LEFT JOIN
	tblCreditor AS origcred with(nolock) ON ci.ForCreditorID = origcred.CreditorID LEFT OUTER JOIN
	tblContact AS ct with(nolock) ON a.accountid = ct.CreditorID LEFT OUTER JOIN
	tblContactPhone AS cp with(nolock) ON cp.ContactID = ct.ContactID LEFT OUTER JOIN
	tblPhone AS p with(nolock) ON p.PhoneID = cp.PhoneID AND p.PhoneTypeID = 56
WHERE
	(a.AccountID = @accountID)
ORDER BY 
	ct.Created DESC




GRANT EXEC ON stp_NegotiationsSystemNoteInfo TO PUBLIC


