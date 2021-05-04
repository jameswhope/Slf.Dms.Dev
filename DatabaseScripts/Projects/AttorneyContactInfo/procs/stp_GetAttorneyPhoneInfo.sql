IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAttorneyPhoneInfo')
	BEGIN
		DROP  Procedure  stp_GetAttorneyPhoneInfo
	END

GO

CREATE PROCEDURE [dbo].[stp_GetAttorneyPhoneInfo] 
	(	
		@ClientID int 
	)
AS
BEGIN
	SET NOCOUNT ON;
SELECT cp.companyid, cp.phonetype, pt.name [Type], cp.PhoneNumber [Number] 
FROM tblClient cl
INNER JOIN tblcompanyphones cp ON cp.companyid = cl.CompanyID
INNER JOIN tblphonetype pt ON pt.phonetypeid = cp.PhoneType
WHERE ClientID = @ClientID
AND cp.PhoneType IN (46, 47, 50)
ORDER BY phonetype
END


GRANT EXEC ON stp_GetAttorneyPhoneInfo TO PUBLIC



