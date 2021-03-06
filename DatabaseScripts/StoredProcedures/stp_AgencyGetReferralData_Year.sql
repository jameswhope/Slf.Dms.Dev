/****** Object:  StoredProcedure [dbo].[stp_AgencyGetReferralData_Year]    Script Date: 11/19/2007 15:26:52 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetReferralData_Year]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetReferralData_Year]
( 
     @agencyId int, 
     @year int 
) 
AS 
 
SELECT     
	YEAR(DERIVEDTBL.Created) AS [Year], 
	MONTH(DERIVEDTBL.Created) AS [Month], 
	COUNT(DERIVEDTBL.ClientId) AS ReferralCount, 
	SUM(DERIVEDTBL.Debt) AS DebtTotal, 
	DERIVEDTBL.Committed,
	tblClientStatus.[Name] as ClientStatusName,
	tblClientStatus.ClientStatusId

FROM   
	
	tblClient INNER JOIN 
	(SELECT 
		tblEnrollment.ClientId,
		tblEnrollment.Created,
		tblEnrollment.Committed,
		CASE
			WHEN (tblAccount.OriginalAmount IS NULL) THEN tblEnrollment.TotalUnsecuredDebt
			ELSE OriginalAmount
		END AS Debt

		FROM tblEnrollment LEFT OUTER JOIN tblAccount on tblAccount.ClientId=tblEnrollment.ClientId
	) AS DERIVEDTBL 
	ON tblClient.ClientId=DERIVEDTBL.ClientId INNER JOIN
	tblRoadMap ON tblClient.ClientId=tblRoadmap.ClientId INNER JOIN
	tblClientStatus ON tblRoadmap.ClientStatusId=tblClientStatus.ClientStatusId 

WHERE 
    AgencyId = @agencyId 
	AND DATEPART([year], DERIVEDTBL.Created) = @year 
	--last status
	AND tblRoadmap.RoadmapId IN (SELECT TOP 1 RoadmapId FROM tblRoadMap WHERE ClientId=tblClient.ClientId ORDER BY Created DESC)
GROUP BY 
	YEAR(DERIVEDTBL.Created), 
	MONTH(DERIVEDTBL.Created), 
	tblClientStatus.[Name],
	tblClientStatus.ClientStatusId,
	DERIVEDTBL.Committed

ORDER BY 
	YEAR(DERIVEDTBL.Created), 
	MONTH(DERIVEDTBL.Created), 	
	tblClientStatus.ClientStatusId,
	tblClientStatus.[Name],	
	DERIVEDTBL.Committed
GO
