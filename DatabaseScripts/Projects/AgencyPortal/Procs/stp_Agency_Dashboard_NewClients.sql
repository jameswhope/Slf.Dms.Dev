IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Agency_Dashboard_NewClients')
	BEGIN
		DROP  Procedure  stp_Agency_Dashboard_NewClients
	END

GO

create procedure [dbo].[stp_Agency_Dashboard_NewClients]
(
	@UserID int,
	@CompanyID int = -1
)
as
BEGIN
	select count(*) 
	from tblclient c 
	join tbluseragencyaccess a on a.agencyid = c.agencyid and a.userid = @userid
	join tblusercompanyaccess uca on uca.companyid = c.companyid and uca.userid = a.userid and (@CompanyID = -1 or uca.companyid = @CompanyID)
	where month(created) = month(getdate()) and year(created) = year(getdate())
END




GRANT EXEC ON stp_Agency_Dashboard_NewClients TO PUBLIC


