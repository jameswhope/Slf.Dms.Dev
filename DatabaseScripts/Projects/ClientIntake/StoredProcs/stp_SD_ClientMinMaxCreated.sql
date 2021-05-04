IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SD_ClientMinMaxCreated')
	BEGIN
		DROP  Procedure  stp_SD_ClientMinMaxCreated
	END

GO

CREATE Procedure stp_SD_ClientMinMaxCreated
	(
	@UserID int = -1,
	@AgencyID int = 856
	)

AS
BEGIN
	SET NOCOUNT ON;

--declare @AgencyID int
--declare @UserID int
--set @AgencyID = 856

   select min(year(c.created)) [min], max(year(c.created)) [max]
	from tblclient c
	--join tbluseragencyaccess uaa on uaa.agencyid = c.agencyid and uaa.userid = @userid
	--join tblusercompanyaccess uca on uca.userid = uaa.userid and uca.companyid = c.companyid and (@companyid = -1 or uca.companyid = @companyid)
	--join tbluserclientaccess ucc on ucc.userid = uaa.userid and c.created between ucc.clientcreatedfrom and ucc.clientcreatedto
	WHERE c.agencyid = @agencyID

END

GO

/*
GRANT EXEC ON stp_SD_ClientMinMaxCreated TO PUBLIC

GO
*/

