IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwClientNextDepositSchedule')
	BEGIN
		DROP  VIEW vwClientNextDepositSchedule
	END
GO


CREATE VIEW [dbo].[vwClientNextDepositSchedule]
AS
SELECT     
	c.ClientID, 
	case 
		when 
			tblNextComp.NextDepositDate is not null and tblNextComp.NextDepositDate > convert(varchar, getdate(), 101) and day(tblNextComp.NextDepositDate) < c.depositday
		then
			convert(varchar(10), tblNextComp.NextDepositDate, 101)
		else
			dbo.udf_GetNextdepositDate(c.depositday)
	END as NextDepositDate,
	ISNULL(tblNextComp.DepositAmount, c.DepositAmount) AS NextDepositAmount
FROM         
	(
		SELECT     
			ClientId, 
			MIN(NextDepositDate) AS NextDepositDate
		FROM
			(
				SELECT
					ClientId, 
					DATEADD(day, DepositDay - 1, CAST(MONTH(GETDATE()) AS varchar(2)) + '/01/' + CAST(YEAR(GETDATE()) AS varchar(4))) AS NextDepositDate, 
					DepositAmount
				FROM
					dbo.tblRuleACH
				WHERE
					(StartDate <= GETDATE()) AND (EndDate > GETDATE()) AND (EndDate > DATEADD(day, DepositDay - 1, CAST(MONTH(GETDATE()) AS varchar(2)) + '/01/' + CAST(YEAR(GETDATE()) AS varchar(4))))
			UNION ALL
		SELECT     
			ClientID, 
			DepositDate AS NextDepositDate, 
			DepositAmount
		FROM         
			dbo.tblAdHocACH
		WHERE     
			(DepositDate > GETDATE())) AS tblMinDate
		GROUP BY 
			ClientId) AS tblAggregate INNER JOIN
		(
			SELECT     
				ClientId, 
				DATEADD(day, DepositDay - 1, CAST(MONTH(GETDATE()) AS varchar(2)) + '/01/' + CAST(YEAR(GETDATE()) AS varchar(4))) AS NextDepositDate, 
				DepositAmount
			FROM 
				dbo.tblRuleACH AS tblRuleACH_1
			WHERE      
				(StartDate <= GETDATE()) AND (EndDate > GETDATE()) AND (EndDate > DATEADD(day, DepositDay - 1, CAST(MONTH(GETDATE()) AS varchar(2)) + '/01/' + CAST(YEAR(GETDATE()) AS varchar(4))))
			UNION ALL
		SELECT     
			ClientID, 
			DepositDate AS NextDepositDate, 
			DepositAmount
		FROM         
			dbo.tblAdHocACH AS tblAdHocACH_1
		WHERE     
			(DepositDate > GETDATE())) AS tblNextComp 
ON tblNextComp.ClientId = tblAggregate.ClientId AND tblAggregate.NextDepositDate = tblNextComp.NextDepositDate 
RIGHT OUTER JOIN dbo.tblClient AS c 
ON tblNextComp.ClientId = c.ClientID 
where c.depositday is not null

GO

