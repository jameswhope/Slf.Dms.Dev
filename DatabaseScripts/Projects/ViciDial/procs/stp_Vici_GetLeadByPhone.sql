 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_Vici_GetLeadByPhone')
	BEGIN
		DROP  Procedure  stp_Vici_GetLeadByPhone
	END

GO

CREATE Procedure stp_Vici_GetLeadByPhone
@phonenumber varchar(20),
@days int = -60
AS
Begin 
	-- Serach Lead By PhoneNumber
	declare @leadid int
	
	--Search an exact match
	Select top 1 @leadid = la.leadapplicantid from tblleadapplicant la
	Where replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') = @phonenumber 
	and la.created > DateAdd(d,@days,GetDate())
	Order by la.leadapplicantid desc
	
	-- if not found then search by other numbers
	if (@leadid is null)
		Select top 1 @leadid = la.leadapplicantid from tblleadapplicant la
		Where  (replace(replace(replace(replace(la.LeadPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		or replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		--or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @phonenumber )
		and la.created > DateAdd(d,@days,GetDate())
		Order by la.leadapplicantid desc
/*
	-- if not found then search coapplicants
	if (@leadid is null)
		Select top 1 @leadid = leadapplicantid from tblleadcoapplicant la
		Where  replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') = @phonenumber 
		Order by la.leadapplicantid desc
		
	if (@leadid is null)
		Select top 1 @leadid = leadapplicantid from tblleadcoapplicant la
		Where  replace(replace(replace(replace(la.HomePhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		--or replace(replace(replace(replace(la.BusinessPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		or replace(replace(replace(replace(la.CellPhone,'(',''),')',''),' ',''),'-','') like @phonenumber 
		Order by la.leadapplicantid desc
*/
	select @leadid

End
