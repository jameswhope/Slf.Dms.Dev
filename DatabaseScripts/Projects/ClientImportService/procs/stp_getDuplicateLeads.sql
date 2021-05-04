IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_getDuplicateLeads')
	BEGIN
		DROP  Procedure  stp_getDuplicateLeads
	END

GO

CREATE Procedure stp_getDuplicateLeads
	@agencyId int,
	@phoneNumber varchar(16)
AS
BEGIN

	select 
		la.FirstName, la.LastName, la.LeadPhone, la.HomePhone, la.CellPhone, la.BusinessPhone
	from
		tblUser u
		join tblAgency a on a.AgencyId = u.AgencyId
		join tblLeadApplicant la on la.RepId = u.UserId
	where
		1=1
		and a.AgencyId = @agencyId 
		and (Homephone = @phoneNumber
		or BusinessPhone = @phoneNumber
		or CellPhone = @phoneNumber
		or LeadPhone = @phoneNumber)

END