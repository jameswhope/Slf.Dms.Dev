IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SearchLeadByPhone')
	BEGIN
		DROP  Procedure  stp_SearchLeadByPhone
	END

GO

CREATE Procedure stp_SearchLeadByPhone
@phonenumber varchar(20),
@searchcoapp bit = 0
AS
Begin 
	-- Serach Lead By PhoneNumber
	declare @leadid int
	
	--Search an exact match
	Select top 1 @leadid = leadapplicantid from tblleadapplicant la
	Where replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') = @phonenumber 
	Order by la.leadapplicantid desc
	
	-- if not found then search by other numbers
	if (@leadid is null)
		Select top 1 @leadid = leadapplicantid from tblleadapplicant la
		Where  replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		--or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		Order by la.leadapplicantid desc


	-- if not found then search coapplicants
	if (@leadid is null and @searchcoapp = 1) 
	begin
		Select top 1 @leadid = leadapplicantid from tblleadcoapplicant la
		Where  replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') = @phonenumber 
		Order by la.leadapplicantid desc
		
		if (@leadid is null)
			Select top 1 @leadid = leadapplicantid from tblleadcoapplicant la
			Where  replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
			--or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
			or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
			Order by la.leadapplicantid desc
	end

	select @leadid

End
