/****** Object:  StoredProcedure [dbo].[stp_AgencyGetDetail]    Script Date: 11/19/2007 15:26:51 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetDetail]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetDetail]
(
	@agentId int
)

AS

SET NOCOUNT ON

SELECT
	Location,
	ContactName,
	Address,
	AptSuite,
	City,
	State,
	Zip,
	HPhone,
	OPhone,
	CPhone,
	APhone,
	Fax,
	Pager,
	Email,
	SSNTIN,
	LoginId,
	CAST((CASE Suspend
		WHEN 'Y' THEN 0
		ELSE 1	
		END)
	 AS bit) AS IsActive,
	CheckNo,
	IsAttorney,
	EnrollPer,
	MaintPer,
	SettPer,
	DMSEnrollPer,
	DMSMaintPer,
	DMSSettPer
FROM
	SalesAgentHdr
WHERE
	SalesAgentHdr_Id=@agentId
GO
