-- Runs as sql job (KPI Refresh)
declare @startdate datetime, @enddate datetime, @i int

set @i = 0

while @i < 3 begin

set @startdate = cast(cast(month(dateadd(m,-@i,getdate())) as varchar(2)) + '/1/' + cast(year(dateadd(m,-@i,getdate())) as char(4)) as datetime)
set @enddate = dateadd(minute,-1,dateadd(m,1,@startdate))

if @startdate >= '10/1/10' begin

delete from tblRevShareReport where startdate = @startdate
delete from tblRevShareReportByFee where startdate = @startdate
delete from tblRevShareReportDetail where startdate = @startdate


insert
	tblRevShareReport (startdate,total_leads,rev_shares,rev_shares_closed,rev_shares_closed_pct,standard_leads,new_leads,attempted_contact,contacted,rev_shares_contact_pct,rev_shares_cost,lastrefresh)
select 
	@startdate [startdate],
	sum(case when h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16 then 1 else 0 end) [total_leads], 
	sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) [rev_shares],
	sum(case when p.revshare = 1 and l.cost > 0 then 1 else 0 end) [rev_shares_closed],
	case when sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) > 0
		then sum(case when p.revshare = 1 and l.cost > 0 then 1 else 0 end) / sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) 
		else 0
	end [rev_shares_closed_pct],
	sum(case when p.revshare = 0 and l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) [standard_leads],
	sum(case when p.revshare = 1 and l.statusid = 16 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null) then 1 else 0 end) [new_rev_shares],
	sum(case when p.revshare = 1 and v.callsmade is not null then 1 else 0 end) [attempted_contact],
	sum(case when p.revshare = 1 and l.statusid not in (1,15,16,13) then 1 else 0 end) [contacted],
	case when sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) > 0
		then sum(case when p.revshare = 1 and l.statusid not in (1,15,16,13) then 1 else 0 end) / sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) 
		else 0
	end [rev_shares_contact_pct],
	sum(case when p.revshare = 1 then l.cost else 0 end) [rev_shares_cost],
	getdate() [lastrefresh]
from tblleadapplicant l 
join tblleadstatus s on s.statusid = l.statusid
join tblleadproducts p on p.productid = l.productid
left join vw_enrollment_CallsMade v on v.leadapplicantid = l.leadapplicantid
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where 1=1--l.refund = 0
	and p.servicefee > 0
	and (l.created between @startdate and @enddate)
	and p.vendorid not in (207) -- NA(Referral)


insert 
	tblRevShareReportByFee (startdate,servicefee,total_leads,rev_shares,rev_shares_closed,rev_shares_closed_pct,standard_leads,new_leads,attempted_contact,contacted,rev_shares_contact_pct,rev_shares_cost)
select 
	@startdate [startdate],
	p.servicefee, 
	sum(case when h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16 then 1 else 0 end) [total_leads], 
	sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) [rev_shares],
	sum(case when p.revshare = 1 and l.cost > 0 then 1 else 0 end) [rev_shares_closed],
	case when sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) > 0 then 
		sum(case when p.revshare = 1 and l.cost > 0 then 1 else 0 end) / sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) 
		else 0 end [rev_shares_closed_pct],
	sum(case when p.revshare = 0 and l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) [standard_leads],
	sum(case when p.revshare = 1 and l.statusid = 16 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null) then 1 else 0 end) [new_rev_shares],
	sum(case when p.revshare = 1 and v.callsmade is not null then 1 else 0 end) [attempted_contact],
	sum(case when p.revshare = 1 and l.statusid not in (1,15,16,13) then 1 else 0 end) [contacted],
	case when sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) > 0 then
		sum(case when p.revshare = 1 and l.statusid not in (1,15,16,13) then 1 else 0 end) / sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) 
		else 0 end [rev_shares_contact_pct],
	sum(case when p.revshare = 1 then l.cost else 0 end) [rev_shares_cost]
from tblleadapplicant l 
join tblleadstatus s on s.statusid = l.statusid
join tblleadproducts p on p.productid = l.productid
left join vw_enrollment_CallsMade v on v.leadapplicantid = l.leadapplicantid
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where 1=1--l.refund = 0
	and p.servicefee > 0
	and (l.created between @startdate and @enddate)
	and p.vendorid not in (207) -- NA(Referral)
group by p.servicefee 


insert 
	tblRevShareReportDetail (startdate,createddate,servicefee,total_leads,rev_shares,rev_shares_closed,rev_shares_closed_pct,standard_leads,new_leads,attempted_contact,contacted,rev_shares_contact_pct,rev_shares_cost)
select 
	@startdate [startdate],
	convert(varchar(10),l.created,101) [createddate],
	p.servicefee, 
	sum(case when h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16 then 1 else 0 end) [total_leads], 
	sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) [rev_shares],
	sum(case when p.revshare = 1 and l.cost > 0 then 1 else 0 end) [rev_shares_closed],
	case when sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) > 0 then sum(case when p.revshare = 1 and l.cost > 0 then 1 else 0 end) / (sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) + .01) else 0 end [rev_shares_closed_pct],
	sum(case when p.revshare = 0 and l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) [standard_leads],
	sum(case when p.revshare = 1 and l.statusid = 16 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null) then 1 else 0 end) [new_rev_shares],
	sum(case when p.revshare = 1 and v.callsmade is not null then 1 else 0 end) [attempted_contact],
	sum(case when p.revshare = 1 and l.statusid not in (1,15,16,13) then 1 else 0 end) [contacted],
	case when sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) > 0 then sum(case when p.revshare = 1 and l.statusid not in (1,15,16,13) then 1 else 0 end) / sum(case when p.revshare = 1 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1.0 else 0.0 end) else 0 end [rev_shares_contact_pct],
	sum(case when p.revshare = 1 then l.cost else 0 end) [rev_shares_cost]
from tblleadapplicant l 
join tblleadstatus s on s.statusid = l.statusid
join tblleadproducts p on p.productid = l.productid
left join vw_enrollment_CallsMade v on v.leadapplicantid = l.leadapplicantid
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where 1=1--l.refund = 0
	and p.servicefee > 0
	and (l.created between @startdate and @enddate)
	and p.vendorid not in (207) -- NA(Referral)
group by p.servicefee, convert(varchar(10),l.created,101) 


end

set @i = @i + 1

end