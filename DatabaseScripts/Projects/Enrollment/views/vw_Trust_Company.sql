IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vw_Trust_Company')
	BEGIN
		DROP  View vw_Trust_Company
	END
GO

CREATE VIEW vw_Trust_Company 
AS
SELECT t.TrustID, t.Name, t.EffectiveStartDate, t.EffectiveEndDate, tr.CompanyId
FROM tblTrust t
Join 
(SELECT tc.[TrustID], CAST(LTRIM(RTRIM(Split.a.value('.', 'VARCHAR(100)'))) AS Int) AS CompanyId  
 FROM  (SELECT [TrustId],  
         CAST ('<M>' + REPLACE([CompanyIds], ',', '</M><M>') + '</M>' AS XML) AS String  
     FROM  TblTrust) AS tc CROSS APPLY String.nodes ('/M') AS Split(a)) tr on tr.trustid = t.trustid

GO

 