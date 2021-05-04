if exists (select * from sysobjects where name = 'stp_ImportCreditLiability')
	drop procedure stp_ImportCreditLiability
go

create procedure stp_ImportCreditLiability
(
	@CreditLiabilityID int,
	@LeadApplicantID int,
	@ImportedBy int
)
as
begin
	-- CreditorID must exist in lookup table at this point

	insert tblLeadCreditorInstance (leadapplicantid,creditorgroupid,creditorid,accountnumber,balance,name,street,street2,city,stateid,zipcode,phone,created,createdby,modified,modifiedby,CreditLiabilityID)
	select @LeadApplicantID,c.CreditorGroupID,c.CreditorID,l.accountnumber,l.unpaidbalance,c.name,isnull(c.street,''),isnull(c.street2,''),c.city,c.stateid,c.zipcode,case when isnumeric(k.contact) = 1 then k.contact else null end,getdate(),@ImportedBy,getdate(),@ImportedBy,l.CreditLiabilityID
	from tblCreditLiability l
	join tblCreditLiabilityLookup k on k.CreditLiabilityLookupID = l.CreditLiabilityLookupID
	join tblCreditor c on c.CreditorID = k.CreditorID
	where l.CreditLiabilityID = @CreditLiabilityID

	update tblCreditLiability
	set DateImported = getdate(), ImportedBy = @ImportedBy
	where CreditLiabilityID = @CreditLiabilityID

end
go 