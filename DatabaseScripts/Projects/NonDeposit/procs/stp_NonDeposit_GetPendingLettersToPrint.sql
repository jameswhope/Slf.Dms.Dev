 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NonDeposit_GetPendingLettersToPrint')
	BEGIN
		DROP  Procedure  stp_NonDeposit_GetPendingLettersToPrint
	END

GO

CREATE Procedure stp_NonDeposit_GetPendingLettersToPrint
AS
SELECT distinct    
	l.NonDepositLetterId, 
	n.ClientID, 
	l.LetterType,
	l.Filename
FROM 
tblNonDepositLetter AS l WITH (nolock) 
INNER JOIN tblnondeposit n on n.nondepositid = l.nondepositid
INNER JOIN tblMatter m ON m.MatterId = n.MatterId AND m.IsDeleted = 0  
--inner join tblMatterStatus ms ON ms.MatterStatusId = m.MatterStatusId and ms.IsMatterActive = 1 
inner join tblClient AS c WITH (nolock) ON c.ClientID = n.ClientID 
INNER JOIN tblPerson AS p WITH (nolock) ON p.PersonID = c.PrimaryPersonID 
WHERE l.LetterType in ('D5025', 'D5030', 'D5031', 'D5013', 'D8022')
and l.DoNotPrint = 0
AND l.PrintedDate is null
AND c.currentclientstatusid not in (15,16,17,18)	
AND m.matterstatusid not in (2,4) -- Exclude closed, completed matters
order by l.NonDepositLetterId 
