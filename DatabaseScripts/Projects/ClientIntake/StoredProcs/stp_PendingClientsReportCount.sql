IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PendingClientsReportCount')
	BEGIN
		DROP  Procedure  stp_PendingClientsReportCount
	END

GO
/*

Show client count in menu option. Leave where condition as close as posible to the Pending Client Reports to avoid differences 

*/
CREATE Procedure stp_PendingClientsReportCount
(
	@companyid int = null,
	@userid int = null
)
as
begin

declare @agencyid int

select @agencyid = agencyid from tbluser where userid = @userid

-- pending clients
select count(distinct c.clientid) as PendingClients
from tblclient c
join tblimportedclient i on i.importid = c.serviceimportid
join tblleadapplicant l on l.leadapplicantid = i.externalclientid 
	and l.statusid in (10,19,22) -- In Process, Return to Compliance, Return to Attorney
join tblleadproducts pr on pr.productid = l.productid
join tblleadvendors v on pr.vendorid = v.vendorid
join tblperson p on p.personid = c.primarypersonid
left join tblstate s on s.stateid = p.stateid
join tblaccount a on a.clientid = c.clientid
	and a.accountstatusid not in (54,55,169,171) -- Settled Account, Account Removed, Settled Account - Lawsuit Filed Against Creditor, NR
join tblPendingApproval pa on pa.clientid = c.clientid
join tblCompany co on co.companyid = c.companyid	
join tblusercompanyaccess ca on c.companyid = ca.companyid -- access only clients allowed for this user	
where 1=1
	and (@companyid is null or c.companyid = @companyid)
	and ((v.Internal = 0 and v.AgencyID = @AgencyID) or (IsNull(@AgencyID,-1) < 1)) -- user permission on agencies
	and c.currentclientstatusid not in (17)
	and ca.userid = @userid

end