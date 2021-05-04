IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAgencyParentList')
	BEGIN
		DROP  Procedure  stp_GetAgencyParentList
	END

GO

CREATE PROCEDURE [dbo].[stp_GetAgencyParentList] 
	@AgencyID int  
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	a.AgencyId [AgencyId],
			a.[Name] 
	FROM tblAgency a
	INNER JOIN tblChildAgency c ON (a.AgencyId = c.ParentAgencyId)
	WHERE c.AgencyId = @AgencyId
	ORDER BY a.[Name]
END


GO


--GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO