IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAssignLeads')
	BEGIN
		DROP  Procedure  stp_GetAssignLeads
	END

GO

CREATE Procedure stp_GetAssignLeads
AS
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 07/06/2009
-- Description:	Lead Assignments
-- =============================================
CREATE PROCEDURE stp_GetAssignLeads 
	AS
BEGIN
	SET NOCOUNT ON;
SELECT distinct la.LeadApplicantID,
 0 AS Selected, 
la.FullName AS Applicant, 
s.Abbreviation AS State, 
la.HomePhone AS Home, 
la.BusinessPhone AS Business, 
CASE WHEN rm.reason IS NULL OR rm.reason LIKE '%INITALIZE%' THEN ls.Description ELSE ls.description + '/' + rm.Reason END AS Status, 
u.FirstName + ' ' + u.LastName AS Rep, 
DATEDIFF(day, la.Created, GETDATE()) AS Aging 
FROM tblLeadApplicant AS la 
LEFT JOIN tblLeadStatus AS ls ON ls.StatusID = la.StatusID 
LEFT  JOIN tblLeadRoadmap AS rm ON rm.LeadApplicantID = la.LeadApplicantID 
LEFT JOIN tblState AS s ON s.StateID = la.StateID 
LEFT JOIN tblUser AS u ON u.UserID = la.RepID
WHERE (len(la.firstname) > 0 or len(la.lastname) > 0)
END

GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

