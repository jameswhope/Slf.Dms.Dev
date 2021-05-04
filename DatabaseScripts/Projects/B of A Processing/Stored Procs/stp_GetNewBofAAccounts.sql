IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNewBofAAccounts')
	BEGIN
		DROP  Procedure  stp_GetNewBofAAccounts
	END

GO

CREATE PROCEDURE [dbo].[stp_GetNewBofAAccounts] 

	@ClientID VARCHAR(MAX) = '0' 
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @SQL VARCHAR(MAX)

              SELECT @SQL = 'SELECT 
		p.relationship,
        c.AccountNumber,
        p.SSN,
        p.LastName,
        p.FirstName + '' '' + LastName [FullName],
        p.Street,
        p.Street2,
        p.City,
        s.abbreviation,
        p.zipcode,
        c.clientid
        FROM tblclient c
        LEFT JOIN tblperson p ON p.clientid = c.clientid AND p.Relationship = ''Prime''
        LEFT JOIN tblstate s ON s.stateid = p.stateid
        WHERE 
		c.currentclientstatusid not in (15, 17, 18) 
		AND c.TrustID = 24 '
		SELECT @SQL = @SQL + 'AND (c.BofAConversionDate IS NULL OR c.ClientID IN (' + @ClientID + '))'

		EXEC (@SQL)
END
GO

/*
GRANT EXEC ON Stored_Procedure_Name TO PUBLIC

GO
*/

