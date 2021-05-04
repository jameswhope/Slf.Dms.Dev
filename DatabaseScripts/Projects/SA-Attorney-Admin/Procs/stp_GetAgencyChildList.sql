IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetChildAgencyList') 
	BEGIN
		DROP  Procedure  stp_GetChildAgencyList
	END

GO

CREATE PROCEDURE [dbo].[stp_GetChildAgencyList] 
	@ParentAgencyID int = -1 
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	a.AgencyId [AgencyId],
			a.[Name] 
	FROM tblAgency a
	INNER JOIN tblChildAgency c ON (a.AgencyId = c.AgencyId)
	WHERE c.ParentAgencyId = @ParentAgencyId
	ORDER BY a.[Name]
END


GO


---GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO


