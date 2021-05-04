IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_NegotiationStatsGroup')
	BEGIN
		DROP  Procedure  stp_NegotiationStatsGroup
	END

GO

create procedure [dbo].[stp_NegotiationStatsGroup]
(
	@UserID int
)
as
BEGIN
		SELECT     
		tblUser.FirstName + ' ' + tblUser.LastName AS UserName
		, isnull(parentNode.Name,tblNegotiationSettlementStatus.Name) AS Root
		, tblNegotiationSettlementStatus.Name AS [Name],tblsettlements.offerdirection
		, COUNT(*) AS [Total]
		, Min(tblSettlements.SettlementPercent) AS [Min Settlement %]
		, MAX(tblSettlements.SettlementPercent) AS [Max Settlement %]
		, AVG(tblSettlements.SettlementPercent) AS [Avg Settlement %]
		, MIN(tblSettlements.SettlementAmount) AS [Min Settlement Amt]
		, MAX(tblSettlements.SettlementAmount) AS [Max Settlement Amt]
		, AVG(tblSettlements.SettlementAmount) AS [Avg Settlement Amt]
		, SUM(CASE WHEN datediff(d, settlementduedate, getdate()) * - 1 <= 30 THEN 1 ELSE 0 END) AS [Due Under 30 days], 
		SUM(CASE WHEN datediff(d, settlementduedate, getdate()) * - 1 BETWEEN 31 AND 60 THEN 1 ELSE 0 END) AS [Due in 31-60 days], 
		SUM(CASE WHEN datediff(d, settlementduedate, getdate()) * - 1 BETWEEN 61 AND 90 THEN 1 ELSE 0 END) AS [Due in 61-90 days], 
		SUM(CASE WHEN datediff(d, settlementduedate, getdate()) * - 1 > 90 THEN 1 ELSE 0 END) AS [Due +90 days]
	FROM         tblNegotiationSettlementStatus INNER JOIN
						  tblNegotiationRoadmap ON tblNegotiationSettlementStatus.SettlementStatusID = tblNegotiationRoadmap.SettlementStatusID INNER JOIN
						  tblSettlements ON tblNegotiationRoadmap.SettlementID = tblSettlements.SettlementID LEFT OUTER JOIN
						  tblNegotiationSettlementStatus AS parentNode ON 
						  tblNegotiationSettlementStatus.ParentSettlementStatusID = parentNode.SettlementStatusID
	INNER JOIN tblUser ON tblSettlements.CreatedBy = tblUser.UserID
	WHERE  tblNegotiationRoadmap.SettlementStatusID > 1 and 
		(tblSettlements.CreatedBy IN (
			SELECT UserID FROM tblUser AS tblUser_2 WHERE (UserGroupID =(
				SELECT UserGroupID FROM tblUser AS tblUser_1 WHERE (UserID = @UserID))
				)
			)
		)
	GROUP BY tblUser.FirstName + ' ' + tblUser.LastName, parentNode.Name, tblNegotiationSettlementStatus.Name, tblNegotiationSettlementStatus.SettlementStatusID,tblsettlements.offerdirection

END


GO


GRANT EXEC ON stp_NegotiationStatsGroup TO PUBLIC

GO


