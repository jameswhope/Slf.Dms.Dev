IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_removeLeadCreditorInstance ')
	DROP  Procedure  stp_enrollment_getLeads
GO

create procedure stp_enrollment_removeLeadCreditorInstance 
(
	@LeadCreditorInstance int
)
as

-- remove import info so that this account shows up as NR
update tblcreditliability
set dateimported = null, importedby = null
from tblcreditliability l
join tblLeadCreditorInstance i on i.CreditLiabilityID = l.CreditLiabilityID 
and i.LeadCreditorInstance = @LeadCreditorInstance

-- remove the instance
delete 
from tblLeadCreditorInstance 
where LeadCreditorInstance = @LeadCreditorInstance