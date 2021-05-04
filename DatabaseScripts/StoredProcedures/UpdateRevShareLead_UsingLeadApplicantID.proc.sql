CREATE PROCEDURE [dbo].[UpdateRevShareLead_UsingLeadApplicantID]
	@LeadApplicantId int
AS
	update tblleadapplicant
	set cost = p.cost
	from tblleadapplicant l
	join tblleadproducts p on p.productid = l.productid
	where l.cost = 0
	and p.revshare = 1
	and l.leadsourceid not in (4) -- don't update the cost for referrals
RETURN 0