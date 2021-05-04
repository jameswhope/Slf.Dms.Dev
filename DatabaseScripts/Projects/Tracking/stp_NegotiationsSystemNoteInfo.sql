IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationsSystemNoteInfo')
	BEGIN
		DROP  Procedure  stp_NegotiationsSystemNoteInfo
	END

GO

create procedure stp_NegotiationsSystemNoteInfo
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
FROM tblAccount AS a INNER JOIN
	tblCreditorInstance AS ci ON ci.CreditorInstanceID = a.CurrentCreditorInstanceID INNER JOIN
	tblCreditor AS currcred ON currcred.CreditorID = ci.CreditorID INNER JOIN
	tblCreditor AS origcred ON ci.ForCreditorID = origcred.CreditorID LEFT OUTER JOIN
	tblContact AS ct ON currcred.CreditorID = ct.CreditorID LEFT OUTER JOIN
	tblContactPhone AS cp ON cp.ContactID = ct.ContactID LEFT OUTER JOIN
	tblPhone AS p ON p.PhoneID = cp.PhoneID AND p.PhoneTypeID = 57
WHERE
	(a.AccountID = @accountID)
ORDER BY 
	ct.Created DESC


GRANT EXEC ON stp_NegotiationsSystemNoteInfo TO PUBLIC



