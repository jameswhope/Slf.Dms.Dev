IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_KPIReport')
	BEGIN
		DROP  Procedure  stp_KPIReport
	END
GO

create procedure stp_KPIReport
(
	@revshare bit
)
as

declare @subtoday int
declare @start datetime

set @start = dateadd(month,-12,getdate())
set @start = cast(cast(month(@start) as varchar(2)) + '/1/' + cast(year(@start) as char(4)) as datetime)

select @subtoday = count(*)
from tblleadapplicant l
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join vw_ClientTotalDebt d on d.clientid = c.clientid
join tblleadproducts p on p.productid = l.productid 
	and p.revshare = @revshare 
	--and p.vendorid not in (207) -- referral
where c.created > cast(convert(varchar(10),getdate(),101) as datetime)


select
	  StartEnd
	, InternetLeads [Internet Leads]
	, NumCasesAgainstMarketingDollars [Num Cases Against Marketing Dollars]
	, CostPerLead [Cost Per Lead]
	, ConversionPct [Conversion Pct]
	, MarketingBudgetSpent [Marketing Budget Spent]
	, CostPerConversionDay [Cost Per Conversion Day]
	, SubmittedCases [Submitted Cases]
	, isnull(PctofTotal,1) [Submitted Cases Pct]
	, AvgMaintFee [Avg Maint Fee]
	, AvgTotalDebt [Avg Total Debt]
	, Goal
	, case 
		when month(startdate) = month(getdate()) and year(startdate) = year(getdate()) then @subtoday
		else null
	  end [Today]
	, case 
		when Pacing = 0 then 'E' 
		when Pacing > 0 then '+' + cast(Pacing as varchar(5)) 
		else cast(Pacing as varchar(5)) 
	  end [Pacing]
from
	tblKpi
where
	revshare = @revshare 
	and startdate > @start
order by 
	startdate desc
	

-- by day
select
	 [StartEnd]
   , [ConnectDate]
   , [TotalInternet]
   , [NumCasesAgainstMarketingDollars]
   , [CostPerLead]
   , [ConversionPercent]
   , [MarketingBudgetSpentPerDay]
   , [CostPerConversionDay]
   , [TotalNumCases]
   , [PctOfTotal]
   , [AvgMaintFee]
   , [AvgTotalDebt]
   , [Goal] = null
   , [Today] = null
   , [Pacing] = ''
from 
	tblKpiDetail
where
	revshare = @revshare 	
	and startdate > @start
order by
	startdate desc, ConnectDate
	
	
select
       [StartEnd]
      ,[ConnectDate]
      ,[ServiceFee] = cast(ServiceFee as varchar(10)) 
      ,[TotalInternet]
      ,[NumCasesAgainstMarketingDollars]
      ,[CostPerLead]
      ,[ConversionPercent]
      ,[MarketingBudgetSpentPerDay]
      ,[CostPerConversionDay]
      ,[TotalNumCases]
      ,[PctOfTotal]
      ,AvgMaintFee
	  ,AvgTotalDebt 
	  ,[Goal] = null
	  ,[Today] = null
	  ,[Pacing] = ''
from 
	tblKPIServiceFeeDetail
where
	revshare = @revshare 	
	and startdate > @start
order by 
	startdate desc, cast(ConnectDate as datetime)	

