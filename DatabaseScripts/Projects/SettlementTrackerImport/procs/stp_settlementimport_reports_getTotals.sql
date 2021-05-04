IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'stp_settlementimport_reports_getTotals')
	BEGIN
		DROP  Procedure  stp_settlementimport_reports_getTotals
	END

GO

create procedure stp_settlementimport_reports_getTotals
(
@year int,
@month int,
@UseOriginalBalance bit = null
)
as
BEGIN
	declare @tblR table(rOrder int,Paid varchar(100),Fees money,Units int,Balance money,SettlementAmt money,AvgSettlementPct float)

if @UseOriginalBalance = 1
	BEGIN
		insert into @tblR 
		select [rOrder] = 0,[Paid] = Team
		, [Fees] = convert(money,sum((a.originalamount-s.settlementamount)*c.SettlementFeePercentage))
		, [Units] = count(*)
		, [Balance] = sum(a.originalamount)
		, [SettlementAmt] = sum(settlementamt)
		, [AvgSettlementPct] = sum(settlementamt)/ sum(a.originalamount)
		from tblSettlementTrackerImports sti with (nolock) 
		inner join tblsettlements s with(nolock) on s.settlementid = sti.settlementid
		inner join tblaccount a  with(nolock) on a.accountid = s.creditoraccountid
		inner join tblclient c with(nolock) on c.clientid = s.clientid
		where year(date) =@year and month(date) = @month --and canceldate is null
		group by team 
		order by team
	END
ELSE
	BEGIN	
		insert into @tblR 
		select [rOrder] = 0,[Paid] = Team, [Fees] = convert(money,sum(settlementfees)), [Units] = count(*), [Balance] = sum(balance), [SettlementAmt] = sum(settlementamt), [AvgSettlementPct] = sum(settlementamt)/ sum(balance)
		from tblSettlementTrackerImports [sti]
		where year(date) =@year and month(date) = @month --and canceldate is null
		group by team 
		order by team
	END
	
	insert into @tblR	
	select 
	[rOrder] = 0
	,[Paid] = 'TOTAL'
	, [Fees] = sum(fees)
	, [Units] = sum(units)
	, [Balance] = sum(balance)
	, [SettlementAmt] = sum(settlementamt)
	, [AvgSettlementPct] = sum(settlementamt)/ sum(balance)
	from @tblR	

	select [Paid]=isnull(paid,0), [Fees]=isnull(fees,0), [Units]=isnull(units,0), [Balance]=isnull(balance,0), [SettlementAmt]=isnull(SettlementAmt,0)
	, [AvgSettlementPct]=isnull(AvgSettlementPct,0)
	from @tblR	order by rorder
END


GRANT EXEC ON stp_settlementimport_reports_getTotals TO PUBLIC


