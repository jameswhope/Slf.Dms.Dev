IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwNegotiationDistributionSource')
	BEGIN
		DROP VIEW vwNegotiationDistributionSource
	END
GO


CREATE VIEW vwNegotiationDistributionSource 
AS

SELECT     c.ClientID, a.AccountID, p.SSN, p.FirstName + ' ' + p.LastName AS ApplicantFullName, p.LastName AS ApplicantLastName, 
                      p.FirstName AS ApplicantFirstName, ISNULL(s.Abbreviation, 'Non-US') AS ApplicantState, p.City AS ApplicantCity, p.ZipCode AS ApplicantZipCode, 
                      c.AccountNumber AS SDAAccount, c.SDABalance - c.PFOBalance -
                          (SELECT     ISNULL(SUM(Amount), 0) AS Expr1
                            FROM          dbo.tblRegister
                            WHERE      (ClientId = c.ClientID) AND (EntryTypeId = 3) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) 
                      -
                          (SELECT     ISNULL(SUM(Amount), 0) AS Expr1
                            FROM          dbo.tblRegister AS tblRegister_3
                            WHERE      (ClientId = c.ClientID) AND (EntryTypeId = 43) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) 
                      AS FundsAvailable, ISNULL(cr2.Name, ' ') AS OriginalCreditor, cr.Name AS CurrentCreditor, ISNULL(cs.Abbreviation, 'Non-US') AS CurrentCreditorState, 
                      CONVERT(varchar, ci.AccountNumber) AS CurrentCreditorAccountNumber,
                          (SELECT     MIN(CurrentAmount) AS CurrentAmount
                            FROM          dbo.tblAccount
                            WHERE      (ClientID = p.ClientID) AND (AccountStatusID NOT IN (54, 55))) AS LeastDebtAmount, a.CurrentAmount, isnull(ad.Description,'') AS AccountStatus, 
   					  a.AccountStatusID,
                      DATEDIFF(day, a.Created, GETDATE()) AS AccountAge, DATEDIFF(day, ISNULL(YEAR(p.DateOfBirth), YEAR(GETDATE())), YEAR(GETDATE())) AS ClientAge,
                       ISNULL
                          ((SELECT     TOP (1) DATEDIFF(day, ISNULL(Settled, GETDATE()), GETDATE()) AS Expr1
                              FROM         dbo.tblAccount AS sa
                              WHERE     (ClientID = p.ClientID) AND (AccountStatusID IN (54))
                              ORDER BY Settled), 0) AS LastSettled, ISNULL(vd.NextDepositDate, '1/1/1900') AS NextDepositDate, ISNULL(vd.NextDepositAmount, 0) 
                      AS NextDepositAmount,
                          (SELECT     TOP (1) tblSettlements.Created
                            FROM          dbo.tblSettlements inner join tblnegotiationroadmap as nr
										on tblSettlements.settlementid = nr.settlementid
                            WHERE      (CreditorAccountID = a.AccountID) AND (ClientID = a.ClientID) AND (nr.settlementstatusid not in (3,5,6,7,8,9,10,14)) order by tblSettlements.Created desc) AS LastOffer,
                          (SELECT     TOP (1) OfferDirection
                            FROM          dbo.tblSettlements AS tblSettlements_1 inner join tblnegotiationroadmap as nr
										on tblSettlements_1.settlementid = nr.settlementid
                            WHERE      (CreditorAccountID = a.AccountID) AND (ClientID = a.ClientID) AND (nr.settlementstatusid not in (3,5,6,7,8,9,10,14))) AS OfferDirection
FROM         dbo.tblClient AS c INNER JOIN
                      dbo.tblPerson AS p ON c.PrimaryPersonID = p.PersonID AND c.CurrentClientStatusID NOT IN (15, 16, 17, 18) INNER JOIN
                      dbo.tblAccount AS a ON a.ClientID = c.ClientID AND (a.AccountStatusID is null or a.AccountStatusID NOT IN (54, 55)) left JOIN
                      dbo.tblAccountStatus AS ad ON ad.AccountStatusID = a.AccountStatusID INNER JOIN
                      dbo.tblCreditorInstance AS ci ON a.CurrentCreditorInstanceID = ci.CreditorInstanceID INNER JOIN
                      dbo.tblCreditor AS cr ON ci.CreditorID = cr.CreditorID LEFT OUTER JOIN
                      dbo.tblCreditor AS cr2 ON ci.ForCreditorID = cr2.CreditorID LEFT OUTER JOIN
                      dbo.tblState AS s ON p.StateID = s.StateID LEFT OUTER JOIN
                      dbo.tblState AS cs ON cr.StateID = cs.StateID LEFT OUTER JOIN
                      dbo.vwClientNextDepositSchedule AS vd ON vd.ClientId = c.ClientID
WHERE     (c.SDABalance - c.PFOBalance -
                          (SELECT     ISNULL(SUM(Amount), 0) AS Expr1
                            FROM          dbo.tblRegister AS tblRegister_2
                            WHERE      (ClientId = c.ClientID) AND (EntryTypeId = 3) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) 
                      -
                          (SELECT     ISNULL(SUM(Amount), 0) AS Expr1
                            FROM          dbo.tblRegister AS tblRegister_1
                            WHERE      (ClientId = c.ClientID) AND (EntryTypeId = 43) AND (Hold > GETDATE()) AND (Void IS NULL) AND (Bounce IS NULL) AND (Clear IS NULL)) 
                      > 0.10 *
                          (SELECT     MIN(CurrentAmount) AS CurrentAmount
                            FROM          dbo.tblAccount AS a1
                            WHERE      (ClientID = p.ClientID) AND (AccountStatusID NOT IN (54, 55) or accountstatusid is null))) AND ((a.AccountID NOT IN
                          (SELECT     CreditorAccountID
							FROM          dbo.tblSettlements AS tblSettlements_2 inner join tblnegotiationroadmap as nr
									on tblSettlements_2.settlementid = nr.settlementid
							group by CreditorAccountID
							having (max(nr.settlementstatusid) in (3,5,6,7,8,9,10,14)))))
