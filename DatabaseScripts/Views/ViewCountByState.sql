/****** Object:  View [dbo].[ViewCountByState]    Script Date: 11/19/2007 14:47:51 ******/
DROP VIEW [dbo].[ViewCountByState]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewCountByState]
AS
SELECT     TOP 100 PERCENT ISNULL(s.Name, 'Foreign Location') AS Expr1, COUNT(*) AS Expr2
FROM         dbo.tblClient c INNER JOIN
                      dbo.tblPerson p ON c.PrimaryPersonID = p.PersonID LEFT OUTER JOIN
                      dbo.tblState s ON p.StateID = s.StateID
WHERE     (c.CurrentClientStatusID NOT IN (15, 17, 18))
GROUP BY s.Name
ORDER BY s.Name
GO
