/****** Object:  StoredProcedure [dbo].[stp_AgencyGetReferralDataYearsAvailable]    Script Date: 11/19/2007 15:26:52 ******/
DROP PROCEDURE [dbo].[stp_AgencyGetReferralDataYearsAvailable]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[stp_AgencyGetReferralDataYearsAvailable]
(
	@agencyId int
)

AS

SELECT DISTINCT
	DATEPART([year], tblEnrollment.Created)
FROM
	tblEnrollment INNER JOIN
	tblClient ON tblEnrollment.ClientId=tblClient.ClientId
WHERE
	tblClient.AgencyId = @agencyId
ORDER BY
	DATEPART([year], tblEnrollment.Created) DESC
GO
