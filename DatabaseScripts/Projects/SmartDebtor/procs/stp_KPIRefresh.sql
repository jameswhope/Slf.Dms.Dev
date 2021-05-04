IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_KPIRefresh')
		DROP  Procedure  stp_KPIRefresh
GO

create procedure stp_KPIRefresh
(
	@startDate datetime,
	@endDate datetime,
	@revshare bit
)
as
BEGIN
/* 
	Replaces stp_SmartDebtor_KPI_Grouping (Oct 2010 on)

	11/11/10	Total internet leads = leads with bank account of checking, savings, or unknown, that non-rev shares
				or successful rev shares or if they dont have one of these bank account types but have been worked on.
	11/24/10	Filter by revshare products
*/

declare @StartEnd varchar(20)
set @StartEnd = datename(m,@startDate) + ' ' + datename(yy,@startDate)

-- Submitted cases
declare @submitted table (submitted varchar(10), cases int, avgmaintfee money, avgdebt money)
declare @cases money, @pacing int, @avgmaintfee money, @avgdebt money, @goal int, @pacinggoal int


-- by month
select 
	@cases = count(*), 
	@avgmaintfee = avg(c.maintfee), 
	@avgdebt = avg(d.totalenrolled)
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join vw_ClientTotalDebt d on d.clientid = c.clientid
join tblleadproducts p on p.productid = l.productid 
	and p.revshare = @revshare 
	--and p.vendorid not in (207) -- referral
where c.created between @startdate and @enddate

select @goal = sum(goal), @pacinggoal = sum(case when [date] < dateadd(day,-1,getdate()) then goal else 0 end)
from tblleadgoals
where [date] between @startdate and @enddate

-- pacing, not currently rev share specific
select @pacing = sum(case when c.created < cast(convert(varchar(10),getdate(),101) as datetime) then 1 else 0 end)
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join vw_ClientTotalDebt d on d.clientid = c.clientid
join tblleadproducts p on p.productid = l.productid 
	--and p.vendorid not in (207) -- referral
where c.created between @startdate and @enddate


-- by service fee
select isnull(c.maintfee,a.maintenancefeecap) [maintfee], count(*) [cases], avg(d.totalenrolled) [avgdebt]
into #byfee
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join vw_ClientTotalDebt d on d.clientid = c.clientid
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join tblleadproducts p on p.productid = l.productid 
	and p.revshare = @revshare 
	--and p.vendorid not in (207) -- referral
where c.created between @startdate and @enddate
group by isnull(c.maintfee,a.maintenancefeecap)


-- by service fee, by day
select convert(varchar(10),c.created,101) [submitted], isnull(c.maintfee,a.maintenancefeecap) [maintfee], count(*) [cases], avg(d.totalenrolled) [avgdebt]
into #byday
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join vw_ClientTotalDebt d on d.clientid = c.clientid
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join tblleadproducts p on p.productid = l.productid 
	and p.revshare = @revshare 
	--and p.vendorid not in (207) -- referral
where c.created between @startdate and @enddate
group by convert(varchar(10),c.created,101), isnull(c.maintfee,a.maintenancefeecap)


delete from tblKPI where StartEnd = @StartEnd and revshare = @revshare 
delete from tblKPIDetail where StartEnd = @StartEnd and revshare = @revshare 
delete from tblKPIServiceFeeDetail where StartEnd = @StartEnd and revshare = @revshare 


insert 
	tblKPI ([StartDate],[StartEnd],[InternetLeads],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPct],[MarketingBudgetSpent],[CostPerConversionDay],[SubmittedCases],[PctOfTotal],[AvgMaintFee],[AvgTotalDebt],[LastRefresh],[Goal],[Pacing],[RevShare])
select
	  [StartDate] = @startdate 
	, [StartEnd] =  @StartEnd
	, [TotalInternet] = sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) 
	, [NumCasesAgainstMarketingDollars] = sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) 
	, [CostPerLead] = case 
			when sum(case when l.cost > 0 then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end)  -- MarketingBudgetSpentPerDay / TotalInternet
		  end 
	, [ConversionPercent] = case 
			when sum(case when l.cost > 0 then 1 else 0 end) = 0 then 1 
			else sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) / cast(sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) as money) 
		  end 
	, [MarketingBudgetSpentPerDay] = sum(l.cost) 
	, [CostPerConversionDay] = case 
			when sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end)
		  end 
	, [TotalNumCases] = @cases
	, [PctOfTotal] = 1
	, [AvgMaintFee] = @avgmaintfee
	, [AvgTotalDebt] = @avgdebt
	, [LastRefresh] = getdate()
	, [Goal] = @goal
	, [Pacing] = @pacing - @pacinggoal
	, [RevShare] = @revshare
from tblleadapplicant l
join tblleadstatus s on s.statusid = l.statusid
join tblleadproducts p on p.productid = l.productid
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where l.refund = 0 
	and l.leadsourceid in (5) -- internet
	and (l.created between @startdate and @enddate)
	and p.revshare = @revshare
	--and p.vendorid not in (207) -- referral


insert 
	tblKPIDetail ([StartDate],[StartEnd],[ConnectDate],[TotalInternet],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPercent],[MarketingBudgetSpentPerDay],[CostPerConversionDay],[TotalNumCases],[PctOfTotal],[AvgMaintFee],[AvgTotalDebt],[RevShare])
select
	  [StartDate] = @startdate 
	, [StartEnd] = @StartEnd 
	, [MaintFee] = cast(p.servicefee as varchar(10))
	, [TotalInternet] = sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) 
	, [NumCasesAgainstMarketingDollars] = sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) 
	, [CostPerLead] = case 
			when sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end)  -- MarketingBudgetSpentPerDay / TotalInternet
		  end 
	, [ConversionPercent] = case 
			when sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) = 0 then 1 
			else sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) / cast(sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) as money)
		  end 
	, [MarketingBudgetSpentPerDay] = sum(l.cost) 
	, [CostPerConversionDay] = case 
			when sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end)
		  end 
	, [TotalNumCases] = f.cases
	, [PctOfTotal] = f.cases / @cases 
	, [AvgMaintFee] = f.maintfee
	, [AvgTotalDebt] = f.avgdebt
	, [RevShare] = @revshare
from tblleadapplicant l
join tblleadstatus s on s.statusid = l.statusid
join tblleadproducts p on p.productid = l.productid
join #byfee f on f.maintfee = p.servicefee
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where l.refund = 0 
	and l.leadsourceid in (5) -- internet
	and (l.created between @startdate and @enddate)
	and p.revshare = @revshare
	--and p.vendorid not in (207) -- referral
group by p.servicefee, f.cases, f.maintfee, f.avgdebt


insert 
	tblKPIServiceFeeDetail ([StartDate],[StartEnd],[ConnectDate],[ServiceFee],[TotalInternet],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPercent],[MarketingBudgetSpentPerDay],[CostPerConversionDay],[TotalNumCases],[PctOfTotal],[AvgMaintFee],[AvgTotalDebt],[RevShare])
select 
	  [StartDate] = @startdate
	, [StartEnd] = @StartEnd
	, [ConnectDate] = convert(varchar(10),l.created,101)
	, [ServiceFee] = p.servicefee
	, [TotalInternet] = sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) 
	, [NumCasesAgainstMarketingDollars] = sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) 
	, [CostPerLead] = case 
			when sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end)  -- MarketingBudgetSpentPerDay / TotalInternet
		  end 
	, [ConversionPercent] = case 
			when sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) = 0 then 0 
			else sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) / cast(sum(case when l.cost > 0 and (h.bankaccount in ('checking','savings','') or h.bankaccount is null or l.statusid <> 16) then 1 else 0 end) as money)
		  end 
	, [MarketingBudgetSpentPerDay] = sum(l.cost) 
	, [CostPerConversionDay] = case 
			when sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and l.cost > 0 then 1 else 0 end)
		  end 
	, [TotalNumCases] = isnull(d.cases,0)
	, [PctOfTotal] = isnull(cast(d.cases as money) / (select cases from #byfee where maintfee = p.servicefee),0)
	, [AvgMaintFee] = isnull(d.maintfee,0)
	, [AvgTotalDebt] = isnull(d.avgdebt,0)
	, [RevShare] = @revshare
from tblleadapplicant l
join tblleadstatus s on s.statusid = l.statusid
join tblleadproducts p on p.productid = l.productid
left join #byday d on d.maintfee = p.servicefee and d.submitted = convert(varchar(10),l.created,101)
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where l.refund = 0 
	and l.leadsourceid in (5) -- internet
	and (l.created between @startdate and @enddate)
	and p.revshare = @revshare
	--and p.vendorid not in (207) -- referral
	and p.servicefee > 0
group by convert(varchar(10),l.created,101), p.servicefee, d.cases, d.maintfee, d.avgdebt
having isnull(d.cases,0) > 0


drop table #byfee
drop table #byday


END