IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_GetAttorneyContactInfo')
	BEGIN
		DROP  Procedure  stp_GetAttorneyContactInfo
	END

GO

CREATE Procedure stp_GetAttorneyContactInfo
(
	@ClientID int 
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	at.addressTypeName [Type],
	ca.Address1 [Address], 
	ca.address2 [Address2],
	ca.city [City],
	ca.State + ' ' + ca.ZipCode [State] 
	FROM tblCompanyAddresses ca
	INNER JOIN tblcompanyaddresstypes at ON at.addresstypeid = ca.addresstypeid
	WHERE ca.companyid IN (SELECT companyid FROM tblclient WHERE ClientID = @ClientID)
	AND ca.Addresstypeid IN (2, 3, 4)
	ORDER BY at.addresstypeid
END


GRANT EXEC ON stp_GetAttorneyContactInfo TO PUBLIC



