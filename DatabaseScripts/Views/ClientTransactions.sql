/****** Object:  View [dbo].[ClientTransactions]    Script Date: 11/19/2007 14:47:51 ******/
DROP VIEW [dbo].[ClientTransactions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ClientTransactions]
AS
SELECT     TOP 100 PERCENT dbo.tblStatementPersonal.accountnumber, dbo.transSDFPFO.transdate, dbo.transSDFPFO.type, dbo.transSDFPFO.amount, 
                      dbo.transSDFPFO.sdabalance, dbo.transSDFPFO.pfobalance
FROM         dbo.transSDFPFO INNER JOIN
                      dbo.tblStatementPersonal ON dbo.transSDFPFO.clientid = dbo.tblStatementPersonal.clientid
WHERE     (dbo.transSDFPFO.transdate < CONVERT(DATETIME, '2006-11-16 00:00:00', 102)) AND (dbo.transSDFPFO.transdate > CONVERT(DATETIME, 
                      '2006-10-14 00:00:00', 102))
ORDER BY dbo.tblStatementPersonal.accountnumber, dbo.transSDFPFO.transdate

GO
