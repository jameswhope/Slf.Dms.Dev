IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwFirstCoApplicant')
	BEGIN
		DROP  View vwFirstCoApplicant
	END
GO

CREATE VIEW  vwFirstCoApplicant 
AS
SELECT     p1.ClientID, p1.FirstName, p1.LastName, p1.SSN
FROM         dbo.tblPerson AS p1 INNER JOIN
                          (SELECT     MIN(PersonID) AS MinPerson, ClientID
                            FROM          dbo.tblPerson
                            WHERE      (Relationship <> 'prime')
                            GROUP BY ClientID) AS m1 ON p1.PersonID = m1.MinPerson


GO
