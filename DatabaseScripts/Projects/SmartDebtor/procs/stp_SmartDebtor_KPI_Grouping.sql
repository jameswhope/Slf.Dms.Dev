IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_SmartDebtor_KPI_Grouping')
	BEGIN
		DROP  Procedure  stp_SmartDebtor_KPI_Grouping
	END
GO

create procedure stp_SmartDebtor_KPI_Grouping
(
 @startDate datetime,
 @endDate datetime
)
as
BEGIN

--load all valid dnis
declare @phonelists table(forDate datetime, dnis varchar(4))
declare @dnislist table(forDate datetime, dnis varchar(4))

--get max date before startdate
insert into @phonelists 
select distinct fordate, right(phone ,4)
from tblleadphonelist with(nolock)
where fordate = (select max(fordate) from tblleadphonelist with(nolock) where fordate <= @startdate and deleted = 0)

insert into @phonelists
select fordate, dnis
from (
	select distinct fordate, right(phone ,4)[dnis]
	from tblleadphonelist with(nolock) where fordate >= @startdate and deleted = 0
	) r
where not exists (select 1 from @phonelists p where p.fordate = r.fordate and p.dnis = r.dnis)

--select * from @phonelists

declare @forDate datetime, @nextfordate datetime, @dnis char(4)
declare curList cursor for select forDate, dnis from @phonelists

open curList
fetch next from curList into @forDate, @dnis
while @@fetch_status = 0 begin 
	set @nextfordate = null;

	select @nextfordate = min(fordate) from @phonelists where fordate > @fordate;

	if @nextfordate is null begin
		set @nextfordate = dateadd(d,7,@fordate);
	end;

	with mycte as (
		select @fordate as DateValue
		union all 
		select DateValue + 1 
		from    mycte    
		where   DateValue + 1 < convert(varchar,@nextfordate) 
	) 
	insert @dnislist (fordate,dnis) 
	select DateValue, @dnis from mycte where datevalue between @fordate and @nextfordate
	OPTION (MAXRECURSION 0)

	fetch next from curList into @forDate, @dnis
end

close curList
deallocate curList

--select * from @dnislist order by fordate


declare @tblData table(
	[Type] varchar(25),
	DNIS varchar(10),
	I3CallIDKey varchar(150),
	StationID varchar(150),
	initiated datetime
)


insert into @tblData
select 
[Type] = 'INTERNET',
[DNIS] = '00000' ,
[I3CallIDKey] = '00000' ,
[StationID] = '00000' ,
[initiated]= la.created
from tblleadapplicant la with(nolock)
where la.leadsourceid in (5,7,8)  
and la.Created between @startdate and @enddate
and la.refund = 0
and la.cost > 0


insert into @tblData
select
 [Type] = 'PHONE'
,[DNIS] = substring(cd.dnis,5,4)
,[I3CallIDKey] = cd.callid
,[StationID] = case when cd.stationid = 'System' or cd.calldurationseconds < 10 then 'System' else '' end
,[initiated]= cd.ConnectedDate
from [DMF-SQL-0001].i3_cic.dbo.calldetail cd with(nolock)
join @dnislist td on convert(varchar(10),td.fordate,101) = convert(varchar(10),cd.ConnectedDate,101)
	and td.dnis = substring(cd.dnis,charindex(':',cd.dnis)+1,4)
	and td.fordate <= @enddate
join tblleadapplicant l with(nolock) on l.callidkey = cd.callid	
where cd.dnis is not null 
and cd.calldirection = 'inbound' 
and cd.calltype = 'external' 
and cd.ConnectedDate between @startdate and @enddate
and cd.InteractionType = 0 
and l.refund = 0



declare @tblRpt table (ConnectDate varchar(10), 
						TotalInboundCalls int, 
						TotalInternet int, 
						TotalSystemCalls int, 
						TotalCallsAnswered int, 
						NumCasesAgainstMarketingDollars int, 
						CostPerLead Money,
						ConversionPercent float, 
						MarketingBudgetSpentPerDay Money, 
						CostPerConversionDay Money, 
						TotalNumCases int)

-- Submitted cases
declare @submitted table (leadapplicantid int,submitted datetime,servicefee money)

-- this count should match the Verification transfer history
insert into @submitted
select l.leadapplicantid, c.created [submitted], p.servicefee [servicefee]
from tblleadapplicant l 
join vw_leadapplicant_client v on v.leadapplicantid = l.leadapplicantid
join tblclient c on c.clientid = v.clientid
join tblleadproducts p on p.productid = l.productid
where c.created between @startdate and @enddate
	

insert @tblRpt 
select 
 [ConnectDate] = convert(varchar(12),initiated,101) 
, [TotalInboundCalls] = SUM(CASE WHEN [TYPE] = 'PHONE' THEN 1 ELSE 0 END) 
, [TotalInternet] = SUM(CASE WHEN [TYPE] = 'INTERNET' THEN 1 ELSE 0 END) 
, [TotalSystemCalls] = sum(case when Stationid = 'System' then 1 else 0 end) 
, [TotalCallsAnswered] = 0 
, [NumCasesAgainstMarketingDollars] = 0 
, [CostPerLead] = 0  	
, [ConversionPercent] = 0 
, [MarketingBudgetSpentPerDay] = 0 
, [CostPerConversionDay] = 0
, [TotalNumCases] = (select count(leadapplicantid) from @submitted where convert(varchar(12),submitted,101) = convert(varchar(12),initiated,101)) 
from @tblData
group by convert(varchar(12),initiated,101)
order by convert(varchar(12),initiated,101);

declare @numDate varchar(10) 
declare @nextDate varchar(10)
declare NumCur cursor for select convert(varchar(10),connectdate, 101)from @tblRpt 

open NumCur 
fetch next from NumCur into @numDate 
while @@fetch_status = 0 begin 
	declare @numCnt int 

	set @nextDate = convert(varchar(10),dateadd(d,1,@numDate), 101) 

	select @numCnt = count(*)
	from tblleadapplicant l with(nolock) 
	join tblleadstatus s on s.statusid = l.statusid
	join tblleadproducts p on p.productid = l.productid
	where (s.statusgroupid = 100 or l.reasonid = 24) -- success statuses
		and (p.revshare = 0 or l.cost > 0) 
		and (l.created between @numDate and @nextDate)
		and l.refund = 0

	update @tblRpt set NumCasesAgainstMarketingDollars = @numCnt where connectdate between @numDate and @nextDate

	fetch next from NumCur into @numDate 
end 
close NumCur deallocate NumCur 


update @tblRpt
set MarketingBudgetSpentPerDay = cost
from @tblRpt r
join (
	select convert(varchar(10),created,101) [created], sum(cost)[cost]
	from tblleadapplicant with(nolock)
	where refund = 0
	group by convert(varchar(10),created,101)
) l
on l.created = r.ConnectDate


update @tblRpt set CostPerConversionDay = case when NumCasesAgainstMarketingDollars = 0 then 0 else convert(float,MarketingBudgetSpentPerDay) / convert(float,NumCasesAgainstMarketingDollars) end;
update @tblRpt set TotalCallsAnswered = TotalInboundCalls - TotalSystemCalls; 
update @tblRpt set ConversionPercent = NumCasesAgainstMarketingDollars / convert(float,TotalCallsAnswered + TotalInternet) where (TotalCallsAnswered + TotalInternet) > 0


declare @inboundoffset int, @systemoffset int

-- since we weren't tracking inbound calls earlier this year use these call totals tracked manually
if month(@startdate) = 1 and year(@startdate) = 2010 begin
	set @inboundoffset = 855
	set @systemoffset = 160
end
else if month(@startdate) = 2 and year(@startdate) = 2010 begin
	-- this offset accounts for Feb 1-4
	set @inboundoffset = 74
	set @systemoffset = 8
end
else begin
	set @inboundoffset = 0
	set @systemoffset = 0
end


delete from tblkpi where startdate = @startdate
delete from tblkpidetail where startdate = @startdate


INSERT [tblKPI]([StartDate],[StartEnd],[InboundCalls],[InternetLeads],[TotalLeads],[SystemCalls],[CallsAnswered],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPct],[MarketingBudgetSpent],[CostPerConversionDay],[SubmittedCases],[LastRefresh])
select 
  [StartDate] = @startDate 
, [StartEnd] = datename(m,@startDate) + ' ' + datename(yy,@startDate) 
, [InboundCalls] = sum(TotalInboundCalls) + @inboundoffset 
, [InternetLeads] = sum(TotalInternet)
, [TotalLeads] = sum(TotalInboundCalls) + sum(TotalInternet) + @inboundoffset 
, [SystemCalls] = sum(TotalSystemCalls) + @systemoffset 
, [CallsAnswered] = sum(TotalInboundCalls) + @inboundoffset - sum(TotalSystemCalls) - @systemoffset 
, [NumCasesAgainstMarketingDollars] = sum(NumCasesAgainstMarketingDollars)
, [CostPerLead] = Case when (sum(TotalInboundCalls) + sum(TotalInternet)) = 0 Then 0 else sum(MarketingBudgetSpentPerDay) / (sum(TotalInboundCalls) + sum(TotalInternet) + @inboundoffset) end 
, [ConversionPct] = sum(NumCasesAgainstMarketingDollars) / convert(float,sum(TotalInboundCalls) + @inboundoffset - sum(TotalSystemCalls) - @systemoffset + sum(TotalInternet)) 
, [MarketingBudgetSpent] = sum(MarketingBudgetSpentPerDay)
, [CostPerConversionDay] = case when sum(NumCasesAgainstMarketingDollars) = 0 then 0 else sum(MarketingBudgetSpentPerDay) / sum(NumCasesAgainstMarketingDollars)end
, [SubmittedCases] = sum(TotalNumCases)
, [LastRefresh] = getdate()
from @tblRpt   


INSERT [tblKPIDetail]([StartDate],[StartEnd],[ConnectDate],[TotalInboundCalls],[TotalInternet],[TotalLeads],[TotalSystemCalls],[TotalCallsAnswered],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPercent],[MarketingBudgetSpentPerDay],[CostPerConversionDay],[TotalNumCases],PctOfTotal)
select 
 @startDate [StartDate]
,datename(m,@startDate) + ' ' + datename(yy,@startDate) [StartEnd]
,ConnectDate
,TotalInboundCalls
,TotalInternet
,TotalInboundCalls + TotalInternet [TotalLeads]
,TotalSystemCalls
,TotalCallsAnswered
,r.NumCasesAgainstMarketingDollars
,Case when TotalInboundCalls + TotalInternet = 0 Then 0 else MarketingBudgetSpentPerDay/(TotalInboundCalls + TotalInternet) end [CostPerLead]
,ConversionPercent
,MarketingBudgetSpentPerDay
,r.CostPerConversionDay
,TotalNumCases
,(TotalInboundCalls + TotalInternet) / cast(k.TotalLeads as money) [PctOfTotal]
from @tblRpt r
join tblKPI k on k.startdate = @startDate


if @startdate >= '10/1/2010' begin -- when we started the 30-60-90 service fee structure

	INSERT [tblKPIDetail]([StartDate],[StartEnd],[ConnectDate],[TotalInboundCalls],[TotalInternet],[TotalLeads],[TotalSystemCalls],[TotalCallsAnswered],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPercent],[MarketingBudgetSpentPerDay],[CostPerConversionDay],[TotalNumCases],PctOfTotal,Seq)
	select 
	  @startDate [StartDate]
	, datename(m,@startDate) + ' ' + datename(yy,@startDate) [StartEnd]
	, cast(p.servicefee as varchar(10))
	, 0 [TotalInboundCalls]
	, sum(case when l.cost > 0 then 1 else 0 end) [TotalInternet]
	, sum(case when l.cost > 0 then 1 else 0 end) [TotalLeads]
	, 0 [TotalSystemCalls]
	, 0 [TotalCallsAnswered]
	, sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end) [NumCasesAgainstMarketingDollars]
	, case 
		when sum(case when l.cost > 0 then 1 else 0 end) = 0 then 0 
		else (sum(l.cost) / sum(case when l.cost > 0 then 1 else 0 end))  -- MarketingBudgetSpentPerDay / TotalInternet
	  end [CostPerLead]
	, case 
		when sum(case when l.cost > 0 then 1 else 0 end) = 0 then 1 
		else (sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end) / cast(sum(case when l.cost > 0 then 1 else 0 end) as money)) 
	  end [ConversionPercent]
	, sum(l.cost) [MarketingBudgetSpentPerDay]
	, case 
		when sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end) = 0 then 0 
		else sum(l.cost) / sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end)
	  end [CostPerConversionDay]
	, [TotalNumCases] = (select count(leadapplicantid) from @submitted where servicefee = p.servicefee) 
	, sum(case when l.cost > 0 then 1 else 0 end) / cast(r.TotalLeads as money) [pct_of_total]
	, 2
	from @tblRpt k
	join tblleadapplicant l with(nolock) on convert(varchar(10),l.created,101) = k.connectdate
	join tblleadstatus s on s.statusid = l.statusid
	join tblleadproducts p on p.productid = l.productid
	join tblKPI r on r.startdate = @startDate
	where l.refund = 0 
		and p.servicefee > 0
		and l.leadsourceid in (5) -- internet
		and (l.created between @startdate and @enddate)
	group by p.servicefee, r.TotalLeads



	delete from tblKPIServiceFeeDetail where startdate = @startdate

	insert tblKPIServiceFeeDetail([StartDate],[StartEnd],[ConnectDate],[servicefee],[TotalInboundCalls],[TotalInternet],[TotalLeads],[TotalSystemCalls],[TotalCallsAnswered],[NumCasesAgainstMarketingDollars],[CostPerLead],[ConversionPercent],[MarketingBudgetSpentPerDay],[CostPerConversionDay],[TotalNumCases],PctOfTotal)
	select 
		  @startDate [StartDate]
		, datename(m,@startDate) + ' ' + datename(yy,@startDate) [StartEnd]
		, k.connectdate
		, p.servicefee
		, 0 [TotalInboundCalls]
		, sum(case when l.cost > 0 then 1 else 0 end) [TotalInternet]
		, sum(case when l.cost > 0 then 1 else 0 end) [TotalLeads]
		, 0 [TotalSystemCalls]
		, 0 [TotalCallsAnswered]
		, sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end) [NumCasesAgainstMarketingDollars]
		, case 
			when sum(case when l.cost > 0 then 1 else 0 end) = 0 then 0 
			else (sum(l.cost) / sum(case when l.cost > 0 then 1 else 0 end))  -- MarketingBudgetSpentPerDay / TotalInternet
		  end [CostPerLead]
		, case 
			when sum(case when l.cost > 0 then 1 else 0 end) = 0 then 1 
			else (sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end) / cast(sum(case when l.cost > 0 then 1 else 0 end) as money)) 
		  end [ConversionPercent]
		, sum(l.cost) [MarketingBudgetSpentPerDay]
		, case 
			when sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end) = 0 then 0 
			else sum(l.cost) / sum(case when (s.statusgroupid = 100 or l.reasonid = 24) and (p.revshare = 0 or l.cost > 0) then 1 else 0 end)
		  end [CostPerConversionDay]
		, [TotalNumCases] = (select count(leadapplicantid) from @submitted where convert(varchar(12),submitted,101) = k.connectdate and servicefee = p.servicefee) 
		, sum(case when l.cost > 0 then 1 else 0 end) / cast(k.TotalInboundCalls + k.TotalInternet as money) [pct_of_total]
	from @tblRpt k
	join tblleadapplicant l with(nolock) on convert(varchar(10),l.created,101) = k.connectdate
	join tblleadstatus s on s.statusid = l.statusid
	join tblleadproducts p on p.productid = l.productid
	where l.refund = 0 
		and p.servicefee > 0
		and l.leadsourceid in (5) -- internet
		and (l.created between @startdate and @enddate)
	group by k.connectdate, p.servicefee, k.TotalInboundCalls, k.TotalInternet
	order by k.connectdate, p.servicefee

end


END

GRANT EXEC ON stp_SmartDebtor_KPI_Grouping TO PUBLIC