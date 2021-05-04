IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_enrollment_leadAnalysis')
	BEGIN
		DROP  Procedure  stp_enrollment_leadAnalysis
	END
GO

create procedure stp_enrollment_leadAnalysis
(
	@where varchar(max),
	@jointoclients bit,
	@jointodeposits bit
)
as
begin

declare @joinclients varchar(200), @joindeposits varchar(200)

set @joinclients = ''

if @jointoclients = 1 begin
	set @joinclients = 'join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
		join tblclient cl on cl.clientid = v.clientid'
end

if @jointodeposits = 1 begin
	set @joindeposits = 'join vw_ClientDeposits cd on cd.clientid = cl.clientid'
end


exec('
select r.leadapplicantid, datediff(day,l.created,max(r.created)) [days]
into #daystosign
from tblleadstatusroadmap r
join tblleadapplicant l on l.leadapplicantid = r.leadapplicantid
where r.leadstatusid = 6 -- signed
group by r.leadapplicantid, l.created


select l.leadapplicantid, 
	case 
		when a.noaccts is null and a.totaldebt = 0 then 0
		when a.noaccts is null and a.totaldebt > 0 then 1
		else a.noaccts end [noaccts], 
	a.totaldebt, 
	--o.origrepid,
	d.days [daystosign],
	l.reasonid,
	l.behindid,
	l.ssn
into #leads
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
' + @joinclients + '
' + @joindeposits + '
left join #daystosign d on d.leadapplicantid = l.leadapplicantid
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where 1=1 ' + @where + '


select count(*)[num], avg(cast(noaccts as money))[noaccts], avg(totaldebt)[totaldebt], avg(cast(daystosign as money))[daystosign],
	sum(case when daystosign > 0 then 1 else 0 end) [nosigned]
from #leads


-- DEMOGRAPHICS


-- accounts with balances
declare @totalaccounts money, @totalbal money, @totalleads money

select l.leadapplicantid, c.accounttype, count(*) [accounts], sum(unpaidbalance) [total]
into #accounts
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join tblcreditsource s on s.ssn = replace(l.ssn,''-'','''')
join tblcreditliability c on c.reportid = s.reportid and c.unpaidbalance > 0 
' + @joinclients + '
' + @joindeposits + '
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where 1=1 ' + @where + '
group by l.leadapplicantid, c.accounttype

select @totalaccounts = sum(accounts), @totalbal = sum(total), @totalleads = count(distinct leadapplicantid)
from #accounts

select accounttype, 
	sum(accounts) [numaccts], 
	count(distinct leadapplicantid) [leads], 
	sum(accounts) / @totalleads [avgper],
	sum(accounts) / @totalaccounts [pct], 
	avg(total) [avgbal]
from #accounts
group by accounttype
order by [pct] desc



-- types of debt
select l.leadapplicantid, isnull(g.groupname,c.loantype) [accounttype], count(*) [accounts], sum(unpaidbalance) [total]
into #types
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join tblcreditsource s on s.ssn = replace(l.ssn,''-'','''')
join tblcreditliability c on c.reportid = s.reportid and c.unpaidbalance > 0 
' + @joinclients + '
' + @joindeposits + '
left join tblcreditloangroup g on g.loantype = c.loantype
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where 1=1 ' + @where + '
group by l.leadapplicantid, isnull(g.groupname,c.loantype)

select @totalaccounts = sum(accounts), @totalbal = sum(total), @totalleads = count(distinct leadapplicantid)
from #types

select accounttype, 
	sum(accounts) [numaccts], 
	count(distinct leadapplicantid) [leads], 
	sum(accounts) / @totalleads [avgper],
	sum(accounts) / @totalaccounts [pct], 
	avg(total) [avgbal]
from #types
group by accounttype
order by [pct] desc



-- top 10 zip codes
select top 10 left(zipcode,3) + ''**'' [zipcode], count(*) [leads]
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
' + @joinclients + '
' + @joindeposits + '
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where zipcode <> '''' ' + @where + '
group by left(zipcode,3)
order by [leads] desc


-- FICO
select 
	sum(case when src.experian between 300 and 499 then 1 else 0 end) [300-499],
	sum(case when src.experian between 300 and 499 then 1 else 0 end) / (count(*) + 0.0) [300-499pct],
	sum(case when src.experian between 500 and 549 then 1 else 0 end) [500-549],
	sum(case when src.experian between 500 and 549 then 1 else 0 end) / (count(*) + 0.0) [500-549pct],
	sum(case when src.experian between 550 and 599 then 1 else 0 end) [550-599],
	sum(case when src.experian between 550 and 599 then 1 else 0 end) / (count(*) + 0.0) [550-599pct],
	sum(case when src.experian between 600 and 649 then 1 else 0 end) [600-649],
	sum(case when src.experian between 600 and 649 then 1 else 0 end) / (count(*) + 0.0) [600-649pct],
	sum(case when src.experian between 650 and 699 then 1 else 0 end) [650-699],
	sum(case when src.experian between 650 and 699 then 1 else 0 end) / (count(*) + 0.0) [650-699pct],
	sum(case when src.experian between 700 and 749 then 1 else 0 end) [700-749],
	sum(case when src.experian between 700 and 749 then 1 else 0 end) / (count(*) + 0.0) [700-749pct],
	sum(case when src.experian between 750 and 799 then 1 else 0 end) [750-799],
	sum(case when src.experian between 750 and 799 then 1 else 0 end) / (count(*) + 0.0) [750-799pct],
	sum(case when src.experian between 800 and 850 then 1 else 0 end) [800-850],
	sum(case when src.experian between 800 and 850 then 1 else 0 end) / (count(*) + 0.0) [800-850pct]
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join tblcreditsource s on s.ssn = replace(l.ssn,''-'','''')
join tblcreditreport r on r.reportid = s.reportid
join tblcreditsource src on src.reportid = r.reportid
' + @joinclients + '
' + @joindeposits + '
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where src.experian > 0 ' + @where + '



-- Age
select 
	sum(case when datediff(year, l.dob, getdate()) between 0 and 17 then 1 else 0 end) [Under 18],
	sum(case when datediff(year, l.dob, getdate()) between 0 and 17 then 1 else 0 end) / (count(*) + 0.0) [Under18pct],
	sum(case when datediff(year, l.dob, getdate()) between 18 and 24 then 1 else 0 end) [18-24],
	sum(case when datediff(year, l.dob, getdate()) between 18 and 24 then 1 else 0 end) / (count(*) + 0.0) [18-24pct],
	sum(case when datediff(year, l.dob, getdate()) between 25 and 34 then 1 else 0 end) [25-34],
	sum(case when datediff(year, l.dob, getdate()) between 25 and 34 then 1 else 0 end) / (count(*) + 0.0) [25-34pct],
	sum(case when datediff(year, l.dob, getdate()) between 35 and 44 then 1 else 0 end) [35-44],
	sum(case when datediff(year, l.dob, getdate()) between 35 and 44 then 1 else 0 end) / (count(*) + 0.0) [35-44pct],
	sum(case when datediff(year, l.dob, getdate()) between 45 and 54 then 1 else 0 end) [45-54],
	sum(case when datediff(year, l.dob, getdate()) between 45 and 54 then 1 else 0 end) / (count(*) + 0.0) [45-54pct],
	sum(case when datediff(year, l.dob, getdate()) between 55 and 64 then 1 else 0 end) [55-64],
	sum(case when datediff(year, l.dob, getdate()) between 55 and 64 then 1 else 0 end) / (count(*) + 0.0) [55-64pct],
	sum(case when datediff(year, l.dob, getdate()) > 64 then 1 else 0 end) [65+],
	sum(case when datediff(year, l.dob, getdate()) > 64 then 1 else 0 end) / (count(*) + 0.0) [Over65pct]
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
' + @joinclients + '
' + @joindeposits + '
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where year(l.dob) between 1901 and year(getdate()) ' + @where + '


-- Salutation
select 
	sum(case when prefix = ''Mr.'' then 1 else 0 end) [Mr.],
	sum(case when prefix = ''Mr.'' then 1 else 0 end) / (count(*) + 0.0) [MrPct],
	sum(case when prefix in (''Ms.'',''Mrs.'') then 1 else 0 end) [Ms./Mrs.],
	sum(case when prefix in (''Ms.'',''Mrs.'') then 1 else 0 end) / (count(*) + 0.0) [MrsPct],
	sum(case when prefix = '''' or prefix is null then 1 else 0 end) [Unknown],
	sum(case when prefix = '''' or prefix is null then 1 else 0 end) / (count(*) + 0.0) [UnknownPct]
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
' + @joinclients + '
' + @joindeposits + '
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where 1=1 ' + @where + '


-- Status Reasons
declare @num money
select @num = count(*) from #leads

select description [reason], count(*) [count], count(*) / @num [pct]
from #leads l
join tblleadreasons r on r.leadreasonsid = l.reasonid
group by description
order by [count] desc


-- Behind
select 
	case when l.behindid = 0 then ''Unknown'' else b.description end [behind],
	count(*) [count],
	count(*) / @num [pct]
from #leads l
left join tblleadbehind b on b.behindid = l.behindid
group by case when l.behindid = 0 then ''Unknown'' else b.description end
order by [pct] desc


-- Hardship
select 
	case when h.hardship = '''' or h.hardship is null then ''Unknown'' else h.hardship end [hardship], 
	count(*) [count],
	count(*) / @num [pct]
from #leads l
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
group by case when h.hardship = '''' or h.hardship is null then ''Unknown'' else h.hardship end
order by [pct] desc


-- Monthly Income
select 
	sum(case when monthlyincome = 0 then 1 else 0 end) [$0],
	sum(case when monthlyincome = 0 then 1 else 0 end) / @num [$0pct],
	sum(case when monthlyincome between 1 and 999.99 then 1 else 0 end) [Under 1K],
	sum(case when monthlyincome between 1 and 999.99 then 1 else 0 end) / @num [Under 1Kpct],
	sum(case when monthlyincome between 1000 and 2999.99 then 1 else 0 end) [1-3K],
	sum(case when monthlyincome between 1000 and 2999.99 then 1 else 0 end) / @num [1-3Kpct],
	sum(case when monthlyincome between 3000 and 4999.99 then 1 else 0 end) [3-5K],
	sum(case when monthlyincome between 3000 and 4999.99 then 1 else 0 end) / @num [3-5Kpct],
	sum(case when monthlyincome between 5000 and 10000 then 1 else 0 end) [5-10K],	
	sum(case when monthlyincome between 5000 and 10000 then 1 else 0 end) / @num [5-10Kpct],
	sum(case when monthlyincome > 10000 then 1 else 0 end) [+10K],
	sum(case when monthlyincome > 10000 then 1 else 0 end) / @num [+10Kpct],
	sum(case when monthlyincome is null then 1 else 0 end) [Unknown],
	sum(case when monthlyincome is null then 1 else 0 end) / @num [Unknownpct]
from #leads l
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid


-- Top 10 Creditors
select top 10 isnull(g.name,k.creditorname) [creditor], count(*) [count]
from #leads l
join tblcreditsource s on s.ssn = replace(l.ssn,''-'','''')
join tblcreditliability c on c.reportid = s.reportid and c.unpaidbalance > 0 
join tblcreditliabilitylookup k on k.creditliabilitylookupid = c.creditliabilitylookupid
left join tblcreditor cr on cr.creditorid = k.creditorid
left join tblcreditorgroup g on g.creditorgroupid = cr.creditorgroupid
where 1=1 
group by isnull(g.name,k.creditorname)
order by [count] desc



select 
	l.leadapplicantid, 
	cl.clientid, 
	case 
		when cl.currentclientstatusid = 17 then
			case when b.ACH = 1 then ''ACH'' else ''Check'' end
		else 
			min(dd.depositmethod) 
	end [depositmethod], 
	sum(dd.depositamount) [monthlydeposit]
into #clients
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient cl on cl.clientid = v.clientid
join tblclientdepositday dd on dd.clientid = cl.clientid and dd.deleteddate is null
' + @joindeposits + '
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
left join tblleadbanks b on b.leadapplicantid = l.leadapplicantid
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where 1=1 ' + @where + '
group by l.leadapplicantid, cl.clientid, cl.currentclientstatusid, b.ACH
	
	

-- Client deposit method
select 
	sum(case when depositmethod = ''ACH'' then 1 else 0 end) [ACH],
	sum(case when depositmethod = ''ACH'' then 1 else 0 end) / (count(*) + 0.0) [ACHPct],
	sum(case when depositmethod = ''Check'' then 1 else 0 end) [Check],
	sum(case when depositmethod = ''Check'' then 1 else 0 end) / (count(*) + 0.0) [CheckPct]
from #clients


-- Client monthly fee
select cl.clientid, cl.maintfee
into #maintfee
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient cl on cl.clientid = v.clientid
' + @joindeposits + '
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid
where 1=1 ' + @where + '
group by cl.clientid, cl.maintfee

declare @clients int
select @clients = count(*) from #maintfee

select maintfee, count(*) [count], count(*) / (@clients + 0.0) [pct]
from #maintfee
group by maintfee
order by maintfee



-- Client deposit to debt ratio
select
	sum(case when depositpct = 0 then 1 else 0 end) [0%],
	sum(case when depositpct = 0 then 1 else 0 end) / (count(*) + 0.0) [0pct],
	sum(case when depositpct = .01 then 1 else 0 end) [1%],
	sum(case when depositpct = .01 then 1 else 0 end) / (count(*) + 0.0) [1pct],
	sum(case when depositpct = .02 then 1 else 0 end) [2%],
	sum(case when depositpct = .02 then 1 else 0 end) / (count(*) + 0.0) [2pct],
	sum(case when depositpct = .03 then 1 else 0 end) [3%],
	sum(case when depositpct = .03 then 1 else 0 end) / (count(*) + 0.0) [3pct],
	sum(case when depositpct = .04 then 1 else 0 end) [4%],
	sum(case when depositpct = .04 then 1 else 0 end) / (count(*) + 0.0) [4pct],
	sum(case when depositpct = .05 then 1 else 0 end) [5%],
	sum(case when depositpct = .05 then 1 else 0 end) / (count(*) + 0.0) [5pct],
	sum(case when depositpct between .06 and .1 then 1 else 0 end) [6-10%],
	sum(case when depositpct between .06 and .1 then 1 else 0 end) / (count(*) + 0.0) [6-10pct],
	sum(case when depositpct between .11 and .2 then 1 else 0 end) [11-20%],
	sum(case when depositpct between .11 and .2 then 1 else 0 end) / (count(*) + 0.0) [11-20pct],
	sum(case when depositpct > .2 then 1 else 0 end) [+20%],
	sum(case when depositpct > .2 then 1 else 0 end) / (count(*) + 0.0) [+20pct]
from (
	select c.clientid, round(c.monthlydeposit / (sum(a.CurrentAmount) + 0.0),2) [depositpct]
	from tblAccount a 
	join #clients c on c.clientid = a.clientid
	where a.settled is null 
		and a.removed is null
		and a.accountstatusid not in (55,171) -- Removed, NR
	group by c.clientid, c.monthlydeposit
) d



-- Eligible vs Enrolled accounts
select v.clientid, 
	case
		when count(distinct f.creditliabilityid) > 10 then 10
		else count(distinct f.creditliabilityid)
	end [eligible], 
	case 
		when count(distinct f.creditliabilityid) > 10 and count(distinct a.accountid) > 10 then 10
		when count(distinct a.accountid) > count(distinct f.creditliabilityid) then count(distinct f.creditliabilityid)
		else count(distinct a.accountid)
	end [enrolled]
into #enrolled
from vw_CreditLiabilitiesFiltered f
join #leads l on l.leadapplicantid = f.leadapplicantid
join vw_leadapplicant_client v on v.leadapplicantid = f.leadapplicantid
join tblaccount a on a.clientid = v.clientid and a.accountstatusid not in (55,171) -- Removed, NR
group by v.clientid


select 
	Eligible, 
	count(*) [leads],
	case when eligible = 10 then ''10+'' else cast(eligible as varchar(4)) end [eligiblev],
	sum(eligible) [Total_Eligible],		
	sum(enrolled) [Total_Enrolled], 
	sum(eligible) - sum(enrolled) [Deficiency],
	avg(enrolled + 0.0) [Avg_Enrolled],
	sum(enrolled) / sum(eligible + 0.0) [Pct_Enrolled]
from #enrolled
group by eligible
order by eligible



-- Income Types
select monthlyincometypes, count(*) [cnt]
into #incometypes
from #leads l
join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
where monthlyincometypes is not null and monthlyincometypes <> ''-1''
group by monthlyincometypes

declare @income table (incometypeid int, cnt int)
declare @monthlyincometypes varchar(100), @cnt int, @totaltypes money
declare cur cursor for select monthlyincometypes, cnt from #incometypes

open cur
fetch next from cur into @monthlyincometypes, @cnt
while @@fetch_status = 0 begin
	insert @income (incometypeid,cnt)
	select cast([value] as int), @cnt
	from dbo.splitstr(@monthlyincometypes,'','')

	fetch next from cur into @monthlyincometypes, @cnt
end

close cur
deallocate cur

select @totaltypes = sum(cnt) from @income

select t.incometypedescription, sum(cnt) [cnt], sum(cnt) / @totaltypes [pct]
from @income i
join tblClientIncomeTypes t on t.incometypeid = i.incometypeid
group by t.incometypedescription
order by [pct] desc



-- Failed 3PV
select vc.laststep, q.questiontexten [question], q.[order], count(*) [cnt]
into #3pv
from tblleadapplicant l
join tblleadcalculator a on a.leadapplicantid = l.leadapplicantid
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient cl on cl.clientid = v.clientid
' + @joindeposits + '
join tblverificationcall vc on vc.clientid = cl.clientid
	and vc.laststep like ''Question%''
	and vc.completed = 0
join tblverificationquestion q on q.questionid = cast(replace(vc.laststep,''Question '','''') as int)
join vw_enrollment_ver_complete f on f.leadapplicantid = l.leadapplicantid
	and f.completed is null
left join tblleadhardship h on h.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_orig_rep o on o.leadapplicantid = l.leadapplicantid
--left join vw_enrollment_closers ec on ec.leadapplicantid = l.leadapplicantid	
where 1=1 ' + @where + '
group by vc.laststep, q.questiontexten, q.[order]

declare @total3pv money
select @total3pv = sum(cnt) from #3pv

select laststep, question, cnt, cnt / @total3pv [pct]
from #3pv
order by [order]




-- Averages and medians
select avg(eligible + 0.0) [avg_eligible], avg(enrolled + 0.0) [avg_enrolled]
from #enrolled


select top 1 eligible [median_eligible]
from (
	select top 50 percent eligible
	from #enrolled
	order by eligible
) e
order by eligible desc


select top 1 enrolled [median_enrolled]
from (
	select top 50 percent enrolled
	from #enrolled
	order by enrolled
) e
order by enrolled desc


select top 1 maintfee [median_maintfee]
from (
	select top 50 percent maintfee
	from #maintfee
	order by maintfee
) e
order by maintfee desc


select top 1 total_eligible [median_total_eligible]
from (
	select top 50 percent l.leadapplicantid, sum(f.unpaidbalance) [total_eligible]
	from #leads l
	join vw_CreditLiabilitiesFiltered f on f.leadapplicantid = l.leadapplicantid
	group by l.leadapplicantid
	order by [total_eligible]
) e
order by total_eligible desc


-- Monthly deposit ranges
declare @dclients int
select @dclients = count(*) from #clients

select 
	sum(case when monthlydeposit < 50 then 1 else 0 end) [Under $50],
	sum(case when monthlydeposit < 50 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 50 and 59.99 then 1 else 0 end) [$50-59],
	sum(case when monthlydeposit between 50 and 59.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 60 and 69.99 then 1 else 0 end) [$60-69],
	sum(case when monthlydeposit between 60 and 69.99 then 1 else 0 end) / (@dclients + 0.0), 
	sum(case when monthlydeposit between 70 and 79.99 then 1 else 0 end) [$70-79],
	sum(case when monthlydeposit between 70 and 79.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 80 and 89.99 then 1 else 0 end) [$80-89],
	sum(case when monthlydeposit between 80 and 89.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 90 and 99.99 then 1 else 0 end) [$90-99],
	sum(case when monthlydeposit between 90 and 99.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 100 and 109.99 then 1 else 0 end) [$100-109],
	sum(case when monthlydeposit between 100 and 109.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 110 and 119.99 then 1 else 0 end) [$110-119],
	sum(case when monthlydeposit between 110 and 119.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 120 and 129.99 then 1 else 0 end) [$120-129],
	sum(case when monthlydeposit between 120 and 129.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 130 and 139.99 then 1 else 0 end) [$130-139],
	sum(case when monthlydeposit between 130 and 139.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 140 and 149.99 then 1 else 0 end) [$140-149],
	sum(case when monthlydeposit between 140 and 149.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 150 and 159.99 then 1 else 0 end) [$150-159],
	sum(case when monthlydeposit between 150 and 159.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 160 and 169.99 then 1 else 0 end) [$160-169],
	sum(case when monthlydeposit between 160 and 169.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 170 and 179.99 then 1 else 0 end) [$170-179],
	sum(case when monthlydeposit between 170 and 179.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 180 and 189.99 then 1 else 0 end) [$180-189],
	sum(case when monthlydeposit between 180 and 189.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 190 and 199.99 then 1 else 0 end) [$190-199],
	sum(case when monthlydeposit between 190 and 199.99 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit between 200 and 210.00 then 1 else 0 end) [$200-210],
	sum(case when monthlydeposit between 200 and 210.00 then 1 else 0 end) / (@dclients + 0.0),
	sum(case when monthlydeposit > 210 then 1 else 0 end) [Over $210],
	sum(case when monthlydeposit > 210 then 1 else 0 end) / (@dclients + 0.0)
from #clients 



drop table #enrolled
drop table #3pv
drop table #incometypes
drop table #maintfee
drop table #clients
drop table #daystosign
drop table #leads
drop table #accounts
drop table #types
')

end
go