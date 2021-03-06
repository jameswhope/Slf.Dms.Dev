----4** Testing Build**/

DROP PROCEDURE [dbo].[stp_AgencyGetList]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetList]

AS

SET NOCOUNT ON

SELECT
	SalesAgentHdr_Id,
	Location,
	ContactName,
	CAST((CASE Suspend
		WHEN 'Y' THEN 0
		ELSE 1	
		END)
	 AS bit) AS IsActive
FROM
	SalesAgentHdr
GO
