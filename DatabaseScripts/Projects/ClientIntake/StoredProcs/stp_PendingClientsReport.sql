IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_PendingClientsReport')
	BEGIN
		DROP  Procedure  stp_PendingClientsReport
	END

GO

CREATE Procedure  [dbo].[stp_PendingClientsReport]
(
	@companyid int = null,
	@userid int = null
)
as
begin

declare @agencyid int

select @agencyid = agencyid from tbluser where userid = @userid

-- pending clients
select c.clientid, c.accountnumber, l.leadapplicantid, p.firstname + ' ' + p.lastname [name], s.name [state], datediff(d,c.created,getdate()) [daysinservice],
	sum(a.currentamount) [totaldebt], count(a.accountid) [nocreditors],
	c.depositamount [deposittotal], co.shortconame [lawfirm]
into #clients
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
	and ((v.Internal = 0 and v.AgencyID = @AgencyID) or (IsNull(@AgencyID,-1) < 1))
	and c.currentclientstatusid not in (17)
	and ca.userid = @userid
group by c.clientid, c.accountnumber, l.leadapplicantid, p.firstname, p.lastname, s.name, c.created, c.depositamount, co.shortconame


/*select c.*, sum(d.depositamount) [deposittotal]
from #clients c
join tblclientdepositday d on d.clientid = c.clientid
group by c.clientid, c.accountnumber, c.leadapplicantid, c.name, state, c.daysinservice, totaldebt, nocreditors
*/

select *
from #clients
order by daysinservice desc


-- account detail
select c.clientid, g.name [creditor], a.currentamount
from #clients c
join tblaccount a on a.clientid = c.clientid
	and a.accountstatusid not in (54,55,169) -- Settled Account, Account Removed, Settled Account - Lawsuit Filed Against Creditor
join tblcreditorinstance ci on ci.creditorinstanceid = a.currentcreditorinstanceid
join tblcreditor cr on cr.creditorid = ci.creditorid
join tblcreditorgroup g on g.creditorgroupid = cr.creditorgroupid
	
	
-- hardship info
select c.clientid, 
	case 
		when len(h.hardshipother) > 0 then h.hardshipother 
		when len(h.hardship) > 0 then h.hardship
		else 'None'
	end [hardship], 
	h.monthlyincome
from #clients c
left join tblleadhardship h on h.leadapplicantid = c.leadapplicantid
	  
	  
drop table #clients

end



