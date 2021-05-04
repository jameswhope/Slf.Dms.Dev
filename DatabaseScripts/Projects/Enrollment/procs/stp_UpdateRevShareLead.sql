IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_UpdateRevShareLead')
	BEGIN
		DROP  Procedure  stp_UpdateRevShareLead
	END
GO

create procedure stp_UpdateRevShareLead
(
	@clientid int
)
as
begin
-- Runs when underwriting gets resolved. 


update tblleadapplicant
set cost = p.cost
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid 
join tblleadproducts p on p.productid = l.productid
where l.cost = 0
and p.revshare = 1
and v.clientid = @clientid 
and l.leadsourceid not in (4) -- don't update the cost for referrals


end
go