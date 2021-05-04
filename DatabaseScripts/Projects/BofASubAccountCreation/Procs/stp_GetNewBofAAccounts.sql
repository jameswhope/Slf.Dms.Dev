IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetNewBofAAccounts')
	BEGIN
		DROP  Procedure  stp_GetNewBofAAccounts
	END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jim Hope
-- Create date: 11/05/2009
-- Description:	Gathers new BofA account conversions
-- =============================================
CREATE PROCEDURE stp_GetNewBofAAccounts 

	@ClientID VARCHAR(MAX) = '0', 
	@TrustID VARCHAR(5) = '0'
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
        JOIN tblperson p ON p.clientid = c.clientid
        JOIN tblstate s ON s.stateid = p.stateid
        WHERE 
		c.currentclientstatusid not in (15, 17, 18) 
        and p.personid = c.primarypersonid 
        and c.BofAConversionDate IS NOT NULL '
		SELECT @SQL = @SQL + 'AND (c.trustid IN (' + @TrustID + ') OR c.ClientID IN (' + @ClientID + '))'

		EXEC (@SQL)
END
GO
