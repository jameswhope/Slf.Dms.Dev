IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getPaid')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getPaid
	END

GO

create procedure stp_settlementimport_reports_getPaid
(
@year int,
@month int,
@UseOriginalBalance bit = null
)
as
BEGIN

	declare @tblR table(rOrder int,Paid varchar(100),Fees money,Units int,PctPaid float,AvgSettlementFeeAmt money,AvgSettlementPct float,totunits int,totfees money,totsettamt money,totcredbal money)
if @UseOriginalBalance = 1
	BEGIN
		insert into @tblR 
		select 
		[rOrder] = 0
		,[Paid] = Team
		, [Fees] = sum(case when year(paid) = @year and month(paid) = @month  then (a.originalamount-s.settlementamount)*c.SettlementFeePercentage else 0 end)
		, [Units] = sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end)
		, [PctPaid] = convert(float,sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end))/isnull(nullif(convert(float,(select count(*) from tblSettlementTrackerImports with(nolock) where year(date) = @year and month(date) = @month and team = sti.team)),0),1)
		, [AvgSettlementFeeAmt] = case when sum(case when year(paid) = @year and month(paid) = @month  then 1 else 0 end) =0 then 0 else sum(case when year(paid) = @year and month(paid) = @month  then (a.originalamount-s.settlementamount)*c.SettlementFeePercentage else 0 end)/ sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end) end
		, [AvgSettlementPct] = sum(case when year(paid) = @year and month(paid) = @month then settlementamt else 0 end)/isnull(nullif(sum(case when year(paid) = @year and month(paid) = @month then a.originalamount else 0 end),0),1)
		,[totunits]=isnull(nullif(convert(float,(select count(*) from tblSettlementTrackerImports where year(date) = @year and month(date) = @month and team = sti.team)),0),1)
		,[totfees]=sum(case when year(paid) = @year and month(paid) = @month then (a.originalamount-s.settlementamount)*c.SettlementFeePercentage else 0 end)
		,[totsettamt]=sum(case when year(paid) = @year and month(paid) = @month then settlementamt else 0 end)
		,[totcredbal]=sum(case when year(date) = @year and month(date) = @month then a.originalamount else 0 end)
		from tblSettlementTrackerImports sti with (nolock) 
		inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid
		inner join tblaccount a  with(nolock) on a.accountid = s.creditoraccountid
		inner join tblclient c with(nolock) on c.clientid = s.clientid
		where not paid is null and canceldate is null and expired is null
		group by team 
		having sum(case when year(paid) = @year and month(paid) = @month and not paid is null then 1 else 0 end)>=1
		order by team	
		option (fast 10)
	
	END
ELSE
	BEGIN	
		insert into @tblR 
		select 
		[rOrder] = 0
		,[Paid] = Team
		, [Fees] = sum(case when year(paid) = @year and month(paid) = @month  then settlementfees else 0 end)
		, [Units] = sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end)
		, [PctPaid] = convert(float,sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end))/isnull(nullif(convert(float,(select count(*) from tblSettlementTrackerImports where year(date) = @year and month(date) = @month and team = sti.team)),0),1)
		, [AvgSettlementFeeAmt] = case when sum(case when year(paid) = @year and month(paid) = @month  then 1 else 0 end) =0 then 0 else sum(case when year(paid) = @year and month(paid) = @month  then settlementfees else 0 end)/ sum(case when year(paid) = @year and month(paid) = @month then 1 else 0 end) end
		, [AvgSettlementPct] = sum(case when year(paid) = @year and month(paid) = @month then settlementamt else 0 end)/isnull(nullif(sum(case when year(paid) = @year and month(paid) = @month then balance else 0 end),0),1)
		,[totunits]=isnull(nullif(convert(float,(select count(*) from tblSettlementTrackerImports where year(date) = @year and month(date) = @month and team = sti.team)),0),1)
		,[totfees]=sum(case when year(paid) = @year and month(paid) = @month then settlementfees else 0 end)
		,[totsettamt]=sum(case when year(paid) = @year and month(paid) = @month then settlementamt else 0 end)
		,[totcredbal]=sum(case when year(date) = @year and month(date) = @month then balance else 0 end)
		from tblSettlementTrackerImports [sti]
		where not paid is null and canceldate is null and expired is null
		group by team 
		having sum(case when year(paid) = @year and month(paid) = @month and not paid is null then 1 else 0 end)>=1
		order by team
	END

insert into @tblR	
select [rOrder] = 1,[Paid] = 'TOTAL', [Fees] = sum(fees), [Units] = sum(units), [PctPaid] = cast(sum(units) as float)/cast(isnull(nullif(sum(totunits),0),1) as float)
, [AvgSettlementFeeAmt] = sum(totfees)/isnull(nullif(sum(units),0),1), [AvgSettlementPct] = sum(totsettamt)/isnull(nullif(sum(totcredbal),0),1),[totunits]=sum(totunits)
,[totfees]=sum(totfees),[totsettamt] = sum(totsettamt),[totcredbal] = sum(totcredbal)
from @tblR	


	select [Paid]=isnull(paid,0), [Fees]=isnull(fees,0), [Units]=isnull(units,0), [PctPaid]=isnull(pctpaid,0), [AvgSettlementFeeAmt]=isnull(AvgSettlementFeeAmt,0)
	, [AvgSettlementPct]=isnull(AvgSettlementPct,0)
	from @tblR	order by rorder

END

GRANT EXEC ON stp_settlementimport_reports_getPaid TO PUBLIC



