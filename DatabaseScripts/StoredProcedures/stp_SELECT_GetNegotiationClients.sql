/****** Object:  StoredProcedure [dbo].[stp_SELECT_GetNegotiationClients]    Script Date: 11/19/2007 15:27:43 ******/
DROP PROCEDURE [dbo].[stp_SELECT_GetNegotiationClients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[stp_SELECT_GetNegotiationClients]
@percent varchar(3)
as
SELECT     c.AccountNumber AS [SDA Acct #], p.FirstName AS [App. First Name], p.LastName AS [App. Last Name], SUBSTRING(p.SSN, 1, 3) 
                      + '-' + SUBSTRING(p.SSN, 4, 2) + '-' + SUBSTRING(p.SSN, 6, 4) AS [App. SSN], ISNULL(p2.FirstName, ' ') AS [CoApp. First Name], ISNULL(p2.LastName, 
                      ' ') AS [CoApp. Last Name], ISNULL(SUBSTRING(p2.SSN, 1, 3) + '-' + SUBSTRING(p2.SSN, 4, 2) + '-' + SUBSTRING(p2.SSN, 6, 4), ' ') AS [CoApp. SSN],
                          (SELECT     TOP (1) Balance
                            FROM          tblRegister AS r
                            WHERE      (ClientId = c.ClientID)
                            ORDER BY RegisterId DESC) AS [SDA Balance], ISNULL(cr2.Name, ' ') AS [Orig.Creditor], cr.Name AS Creditor, CONVERT(varchar, ci.AccountNumber) 
                      AS [Creditor Acct #], ISNULL(aid.Description, ' ') AS [Acct Status], ci.Amount AS [Current Amount],
                          (SELECT     TOP (1) ci2.Amount
                            FROM          tblCreditorInstance AS ci2 INNER JOIN
                                                   tblAccount AS a2 ON ci2.CreditorInstanceID = a2.CurrentCreditorInstanceID
                            WHERE      (a2.ClientID = c.ClientID)
                            ORDER BY ci2.CreditorInstanceID DESC) * (CONVERT(decimal(18, 2), 10) / 100) AS [%Amt]
FROM         tblClient AS c INNER JOIN
                      tblPerson AS p ON c.PrimaryPersonID = p.PersonID LEFT OUTER JOIN
                          (SELECT     ClientID, FirstName, LastName, SSN
                            FROM          tblPerson AS pij
                            WHERE      (Relationship = 'Spouse')) AS p2 ON p2.ClientID = c.ClientID INNER JOIN
                      tblAccount AS a ON a.ClientID = c.ClientID INNER JOIN
                      tblCreditorInstance AS ci ON a.CurrentCreditorInstanceID = ci.CreditorInstanceID INNER JOIN
                      tblCreditor AS cr ON ci.CreditorID = cr.CreditorID LEFT OUTER JOIN
                      tblCreditor AS cr2 ON ci.ForCreditorID = cr2.CreditorID LEFT OUTER JOIN
                      tblAccountStatus AS aid ON a.AccountStatusID = aid.AccountStatusID
WHERE     (c.CurrentClientStatusID NOT IN (15, 16, 17, 18)) AND (a.AccountStatusID NOT IN (54, 55)) AND
                          ((SELECT     TOP (1) Balance
                              FROM         tblRegister AS r
                              WHERE     (ClientId = c.ClientID)
                              ORDER BY RegisterId DESC) >
                          (SELECT     TOP (1) ci2.Amount
                            FROM          tblCreditorInstance AS ci2 INNER JOIN
                                                   tblAccount AS a2 ON ci2.CreditorInstanceID = a2.CurrentCreditorInstanceID
                            WHERE      (a2.ClientID = c.ClientID)
                            ORDER BY ci2.CreditorInstanceID DESC) * (CONVERT(decimal(18, 2), @percent) / 100)) OR
                      (c.CurrentClientStatusID NOT IN (15, 16, 17, 18)) AND (a.AccountStatusID IS NULL) AND
                          ((SELECT     TOP (1) Balance
                              FROM         tblRegister AS r
                              WHERE     (ClientId = c.ClientID)
                              ORDER BY RegisterId DESC) >
                          (SELECT     TOP (1) ci2.Amount
                            FROM          tblCreditorInstance AS ci2 INNER JOIN
                                                   tblAccount AS a2 ON ci2.CreditorInstanceID = a2.CurrentCreditorInstanceID
                            WHERE      (a2.ClientID = c.ClientID)
                            ORDER BY ci2.CreditorInstanceID DESC) * (CONVERT(decimal(18, 2), @percent) / 100))
ORDER BY [App. Last Name]
GO
